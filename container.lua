local str = require "resty.string"
local template = require "template"
local cjson = require "cjson"

local containerhtml = [[
<style>
</style>
<script
  src="http://code.jquery.com/jquery-2.2.4.min.js"
	integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44="
	crossorigin="anonymous"></script>
<script src="rough.min.js"></script>
<script>
function render() {
	var content = document.getElementById("content");
  $.get("/getstate", function(data) {
	  content.innerHTML = data;
		setTimeout(render, 500);
	})
}
setTimeout(render, 500);
</script>
<canvas id=status class=status width=1400 height=90>
</canvas>
<div id=content>
</div>
<script>
var canvas = document.getElementById('status');
var rc = rough.canvas(canvas);
var context = canvas.getContext('2d');
var i = 1;
var interval = setInterval(function() {
  i = Number(document.getElementById("memsize").value) / 2.0;
	if (i > 120) { i = 120; }
  context.save();
	context.setTransform(1, 0, 0, 1, 0, 0);
	context.clearRect(0, 0, canvas.width, canvas.height);
	context.restore();
	rc.rectangle(5, 5, i * 10, 70, { roughness: i / 100, fill: "rgb(" + (i*2) + ",0," + (255 - (i*2)) + ")" });
}, 100)
</script>
]]

return function (redis, args)
  ngx.header["content-type"] = "text/html"
  ngx.say(containerhtml)
end
