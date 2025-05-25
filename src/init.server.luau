local HttpService = game:GetService("HttpService")
local LogService = game:GetService("LogService")

local ADDRESS = "http://localhost:5642/log"

local queue = {}

local color = {
	white_underline = function(s: string)
		return `\27[1;4m{s}\27[0m`
	end,

	white = function(s: string)
		return `\27[37;1m{s}\27[0m`
	end,

	green = function(s: string)
		return `\27[32;1m{s}\27[0m`
	end,

	red = function(s: string)
		return `\27[31;1m{s}\27[0m`
	end,

	yellow =  function(s: string)
		return `\27[33;1m{s}\27[0m`  
	end,

	orange = function(s: string)
		return `\27[38;5;208m{s}\27[0m`  
	end,
	
	blue = function(s: string)
		return `\27[34;1m{s}\27[0m`  
	end,

	red_highlight = function(s: string)
		return `\27[41;1;30m{s}\27[0m`
	end,

	green_highlight = function(s: string)
		return `\27[42;1;30m{s}\27[0m`
	end,

	gray = function(s: string)
		return `\27[30;1m{s}\27[0m`
	end,
}

LogService.MessageOut:Connect(function(s, message_type: Enum.MessageType)
	if message_type == Enum.MessageType.MessageWarning then
		table.insert(queue, color.orange(s))
	elseif message_type == Enum.MessageType.MessageInfo then
		table.insert(queue, color.blue(s))
	elseif message_type == Enum.MessageType.MessageError then
		table.insert(queue, color.red(s))
	else
		table.insert(queue, s)
	end
end)

while true do
	if #queue == 0 then task.wait(); continue end
	
	local ok, err = pcall(function()
		HttpService:PostAsync(ADDRESS, table.concat(queue, "\n"))
	end)
	queue = {}
	if ok then task.wait(0.1) elseif err:find("Number of request-sending") then warn("oops"); break else task.wait(5) end
end