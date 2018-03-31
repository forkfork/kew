local str = require "resty.string"
local cjson = require "cjson"

return function (redis, args)
	local session = args.session
	if(not session) then
	  ngx.status = 400
		ngx.say("No session ID")
		return
	end

	local message = redis:lpop(session)
	if message == ngx.null then
	  ngx.status = 404
		ngx.say("got nothing")
		return
	end

	ngx.say(message)
end
