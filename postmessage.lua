local str = require "resty.string"
local cjson = require "cjson"

return function (redis, args)
	local message = args.message
	if(not message) then
	  ngx.status = 400
		ngx.say("A message is needed")
		return
	end

	local sessions = redis:smembers("sessions")
	for i = 1, #sessions do
	  redis:rpush(sessions[i], message)
	end

	ngx.say("ok")
end
