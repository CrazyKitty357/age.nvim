--- age.nvim
--- the goal is to effectively be gpg.nvim but repalce pgp with age (actually good encryption).
---
---
---
--- requirements before installing this plugin:
--- age (installed via package manager).



local pub_key = "change this to the public key in the generated keyfile"
local keyfile = "filepath/to/keyfile/goes/here/age.key"

local function normalize_stdout(stdout)
	local output_lines = vim.split(stdout or "", "\n", { plain = true })
	if #output_lines > 0 and output_lines[#output_lines] == "" then
		table.remove(output_lines, #output_lines)
	end
	return output_lines
end

local function age_encrypt(cyphertext)
	return vim.system({ "age", "-r", pub_key, "-a" }, { stdin = cyphertext }):wait()
end

local function age_decrypt(cyphertext)
	return vim.system({ "age", "-d", "-i", keyfile }, { stdin = cyphertext }):wait()
end


-- SETTINGS LOGIC
-- ===============
vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
	pattern = "*.age",
	callback = function()
		-- print("hello world, setting file!")
		vim.opt.shada = ""

		vim.opt_local.swapfile = false

		vim.opt_local.bin = true

		vim.opt_local.undofile = false
		vim.opt_local.writebackup = false
	end,
})

-- DECRYPTION LOGIC
-- ================
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
	pattern = "*.age",
	callback = function()
		-- print("hello world!")
		local buf = vim.api.nvim_get_current_buf()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local input = table.concat(lines, "\n")

		local result = age_decrypt(input)

		local output_lines = normalize_stdout(result["stdout"])
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, output_lines)
		vim.api.nvim_buf_set_option(buf, "modified", false)
	end
})


-- ECRYPTION LOGIC
-- ===============
vim.api.nvim_create_autocmd({ "BufWritePre", "FileWritePre" }, {
	pattern = "*.age",
	callback = function()
		local buf = vim.api.nvim_get_current_buf()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local input = table.concat(lines, "\n")
		local result = age_encrypt(input)
		local output_lines = normalize_stdout(result["stdout"])
		vim.api.nvim_buf_set_lines(buf, 0, -1, false, output_lines)
		vim.api.nvim_buf_set_option(buf, "modified", false)
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost", "FileWritePost" }, {
	pattern = "*.age",
	command = "u"
})

return {}
