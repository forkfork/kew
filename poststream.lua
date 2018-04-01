local str = require "resty.string"
local cjson = require "cjson"

return function (redis, args)
	local message = args.message
	if(not message or message:match("%W")) then
	  ngx.status = 400
		ngx.say("An alphanumeric-only message is needed")
		return
	end

	local sessions = redis:xadd("queue", "*", "message", args.message)

	ngx.say("ok")
end
