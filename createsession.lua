local resty_random = require "resty.random"
local str = require "resty.string"
local cjson = require "cjson"

local rand_hex = function()
  local random = resty_random.bytes(4)
	return str.to_hex(random)
end

return function (redis, args)
  local username = args.username
	
	if not username or username:match("%W") or string.len(username) > 12 then
	  ngx.status = 400
		ngx.say("username must be 12 or less alphanumeric characters")
		return
	end

	local session = username .. ":" .. rand_hex()
	redis:sadd("sessions", session)
	redis:sadd("0-0", session)

  local session_details = cjson.encode{
    session = session
  }
	ngx.say(session_details)
end
