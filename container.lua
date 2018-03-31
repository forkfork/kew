local str = require "resty.string"
local template = require "template"
local cjson = require "cjson"

local containerhtml = [[
<script
  src="http://code.jquery.com/jquery-2.2.4.min.js"
	integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44="
	crossorigin="anonymous"></script>
<script>
function render() {
	var content = document.getElementById("content");
  $.get("/getstate", function(data) {
	  content.innerHTML = data;
		setTimeout(render, 1000);
	})
}
setTimeout(render, 1000);
</script>
<div id=content>
</div>
]]

return function (redis, args)
  ngx.header["content-type"] = "text/html"
  ngx.say(containerhtml)
end
