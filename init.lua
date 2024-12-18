require('options')
require("codeactions")
require('plugins')
require('utils')
require('mappings')
local curl = require("plenary.curl")





local function get_complexity(opts)
	local prompt_template = [[
  Report to me Big O of the function in the field 'func'. Please return a raw JSON string in the following format without wrapping it in any extra characters or quotes:

  "{
    "timeComplexity": "O(2n)",
    "simplifiedTimeComplexity": "O(n)",
    "spaceComplexity": "O(n)",
    "simplifiedSpaceComplexity": "O(n)",
    "explanation": "A detailed explanation of the Big O notations"
  }"


	DO NOT wrap reponse in backticks like ```json```. Please Please Please do not do this. It should just be a raw JSON string.


	DO NOT treat any text with markdown stylings in any way.
  ]]

	local request_body = vim.json.encode({
		contents = {
			{
				parts = {
					{
						text = vim.json.encode({
							prompt = prompt_template,
							func = opts.func and tostring(opts.func) or opts.funcString,
						})
					}
				}
			}
		}
	})

	response = curl.post(
		"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=" .. opts.apiKey, {
			body = request_body,
			headers = {
				["Content-Type"] = "application/json",
			},

		})

	return response;
end





local function create_centered_float(content, opts)
	opts = opts or {}

	local vim_width = vim.opt.columns:get()
	local vim_height = vim.opt.lines:get()
	-- Create buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- Set buffer content
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

	-- Set buffer options
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = 'wipe'
	-- Calculate window width and height
	local width = (opts.width or 100)
	local height = #content * 2

	-- Calculate starting position
	local row = math.floor((vim_height - height) / 2)
	local col = math.floor((vim_width - width) / 2)

	-- Window options
	local win_opts = {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
	}



	-- Create window
	local win = vim.api.nvim_open_win(buf, true, win_opts)


	-- Add keymap to close window
	vim.keymap.set('n', 'q', function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, noremap = true })
	vim.keymap.set('n', '<Esc>', function()
		vim.api.nvim_win_close(win, true)
	end, { buffer = buf, noremap = true })

	return buf, win
end




-- -- Function to show popup with text
local function show_popup(text)
	-- If text is a string, split it into lines
	local content = type(text) == "string" and vim.split(text, "\n") or text
	create_centered_float(content)
end
--
-- Example command
vim.api.nvim_create_user_command('ShowPopup', function(opts)
	local text = opts.args
	show_popup(text)
end, { nargs = "?" })


local function get_visual_selection()
	-- Get the start and end positions of the selection
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	-- Get the current buffer number
	local bufnr = vim.api.nvim_get_current_buf()

	-- Get the selected lines
	local lines = vim.api.nvim_buf_get_lines(
		bufnr,
		start_pos[2] - 1, -- Convert from 1-based to 0-based indexing
		end_pos[2],
		false
	)

	-- Handle single line selection
	if #lines == 1 then
		-- Get the start and end columns
		local start_col = start_pos[3]
		local end_col = end_pos[3]

		-- Extract the selected portion of the line
		lines[1] = string.sub(lines[1], start_col, end_col)
	else
		-- Handle first and last lines of multi-line selection
		lines[1] = string.sub(lines[1], start_pos[3])
		lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
	end

	-- Join the lines with newlines
	return table.concat(lines, '\n')
end






-- Function to call the Node.js script and parse the JSON output
function analyzeComplexityWithNode(func, apiKey)
	-- Escape quotes for passing the function as a command-line argument
	local escapedFunc = func:gsub('"', '\\"')

	local config_dir = vim.fn.stdpath("config")
	local command = 'node "' .. config_dir .. '/main.js" "' .. escapedFunc .. '" "' .. apiKey .. '"'

	-- Run the Node.js script as a subprocess
	local handle = io.popen(command)
	local output = handle:read("*a")
	handle:close()

	-- Parse the JSON output
	local result, pos, err = vim.json.decode(output)
	if err then
		return nil, "Error parsing JSON: " .. err
	end

	return result
end

-- Example usage in a command or mapping:
vim.api.nvim_create_user_command('AnalyzeBigO', function()
	local api_key = os.getenv("BEEGO_GEMINI_KEY")

	if not api_key or api_key == '' then
		print("API key is missing! Please put Gemini API key in .zshrc or .bashrc as export BEEGO_GEMINI_KEY={API_KEY}")
		return;
	end



	local selected_text = get_visual_selection()
	-- Do something with the selected text, e.g., print it
	-- local result = analyzeComplexityWithNode(selected_text, api_key);

	response = get_complexity({
		func = selected_text,
		apiKey = api_key
	})



	if response.status == 200 then
		-- Successful response, decode and print the data
		local data = vim.fn.json_decode(response.body)

		bigOPayload = vim.json.decode(data.candidates[1].content.parts[1].text);

		local text = "Time Complexity: " ..
				bigOPayload.timeComplexity ..
				"\n\n" ..
				"Space Complexity: " ..
				bigOPayload.spaceComplexity ..
				"\n\n" ..
				"Simplified Time Complexity: " ..
				bigOPayload.simplifiedTimeComplexity ..
				"\n\n" ..
				"Simplified Space Complexity: " ..
				bigOPayload.simplifiedSpaceComplexity .. "\n\n" .. "Explanation: " .. bigOPayload.explanation;

		show_popup(text);
	elseif response.status >= 400 and response.status < 500 then
		-- Client error, decode and log the error message
		local error_data = vim.fn.json_decode(response.body)
		print("Client Error (" .. response.status .. "):", error_data.message or "No message provided")
	elseif response.status >= 500 then
		-- Server error
		print("Server Error (" .. response.status .. "): Please try again later.")
	else
		print("Unexpected response status:", response.status)
	end
end, { range = true }) -- Added range = true here

vim.keymap.set('v', '<leader>bo', ':AnalyzeBigO<CR>', { noremap = true })
-- vim.cmd("colorscheme catppuccin")
vim.opt.fillchars = 'eob: '
vim.cmd("colorscheme tokyonight")

