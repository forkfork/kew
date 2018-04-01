local str = require "resty.string"
local template = require "template"
local cjson = require "cjson"

local queueshtml = [[
<style>
.session {
  float: left;
  padding: 10px;
  width: 220px;
  margin-top: 1px;
  margin-bottom: 1px;
}
.item {
  float: left;
  border: 2px solid black;
  margin-right: 2px;
  padding: 10px;
  margin-top: 1px;
  margin-bottom: 1px;
}
.line {
  display: block;
  clear:both;
  width: 4000px;
}
</style>
{% for i = 1, #messages do %}
  <div class=line>
  <h1 class=session>{*messages[i].message*}</h1>
  {% for n = 1, #messages[i].subs do %}
    <h1 class=item>{{messages[i].subs[n]}}</h1>
  {% end %}
  </div>
{% end %}
]]

local getsubs = function(redis, key)
  local subs = redis:smembers(key)
	local cleansubs = {}
	for i = 1, #subs do
	  cleansubs[#cleansubs + 1] = string.gsub(subs[i], ":.*", "")
	end
	return cleansubs
end

local getmessages = function(redis)
  ngx.header["content-type"] = "text/html"
  local sessions, err = redis:xread("COUNT", 200, "STREAMS", "queue", "0-0")
	if sessions == ngx.null then
	  ngx.say("wat " .. tostring(err))
	  return
	end
  local datapoints = sessions[1][2]
  local messages = {{
    message = "<i>just connected</i>",
    subs = getsubs(redis, "0-0")
  }}
  for i = 1, #datapoints do
    local messageid = datapoints[i][1]
    local subs = getsubs(redis, messageid)
    messages[#messages + 1] = {
      message = datapoints[i][2][2],
      subs = subs
    }
    ngx.log(ngx.ERR, cjson.encode(messages))
  end
  return messages
end

return function (redis, args)
  local messages = getmessages(redis)
  template.render(queueshtml, {messages = messages})
end
