local str = require "resty.string"
local cjson = require "cjson"

return function (redis, args)
	local session = args.session
	local messageid = args.messageid or "0-0"
	ngx.log(ngx.ERR, "message id " .. tostring(messageid))
	if(not session) then
	  ngx.status = 400
		ngx.say("No session ID")
		return
	end

	local message, err = redis:xread("COUNT", 1, "STREAMS", "queue", messageid)
	ngx.log(ngx.ERR, tostring(err))
	if message == ngx.null then
	  ngx.status = 404
		ngx.say("got nothing")
		return
	end
	local datapoint = message[1][2]
  ngx.header["messageid"] = datapoint[1][1]
  redis:smove(messageid, datapoint[1][1], session)
	ngx.say(datapoint[1][2][2])
end
