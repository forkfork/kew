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
{% for i = 1, #queues do %}
  <div class=line>
	<h1 class=session>{{queues[i].username}}</h1>
	{% for n = 1, #queues[i].queue do %}
		<h1 class=item>{{queues[i].queue[n]}}</h1>
	{% end %}
	</div>
{% end %}
]]

local getqueues = function(redis)
  ngx.header["content-type"] = "text/html"
  local sessions = redis:smembers("sessions")
  local queues = {}
	for i = 1, #sessions do
		local username = string.gsub(sessions[i], ":.*", "")
		queues[#queues + 1] = {
		  username = username,
      queue = redis:lrange(sessions[i], 0, -1)
		}
	end
	return queues
end

return function (redis, args)
  local queues = getqueues(redis)
	template.render(queueshtml, {queues = queues})
end
