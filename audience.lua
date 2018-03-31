local html = [[
<script
  src="http://code.jquery.com/jquery-2.2.4.min.js"
	integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44="
	crossorigin="anonymous"></script>
  <link rel="stylesheet" href="http://unpkg.com/papercss@1.4.1/dist/paper.min.css">
<style>
.item {
  float: left;
	border: 2px solid black;
	margin-right: 2px;
	padding: 10px;
	margin-top: 1px;
	margin-bottom: 1px;
}
</style>
<h1 class="article-title">My Queue</h1>
<button id=req class="btn-large" style="width: 60%">Request Message</button>
<br><br>
<div id=content>
</div>
<script>
$(document).ready(function() {

  function getMessage() {
	  $.ajax({
		  type: "POST",
			url: "/getmessage",
			data: JSON.stringify({ session: window.session }),
			success: function(messageResponse) {
				$("#content").append("<h3 class=item>" + messageResponse + "</h3>");
				console.log(messageResponse);
			},
			dataType: "text",
			contentType: "application/json"
		});
	}

  var req = document.getElementById("req");
	req.addEventListener("touchend", function(event) {
	  event.preventDefault();
    getMessage();
	});
	req.addEventListener("click", function(event) {
		getMessage();
	});
	function getUsername() {
		var username = prompt("Please choose a username (alphanumeric, max 12 chars)");
		$.ajax({
		  type: "POST",
			url: "/createsession",
			data: JSON.stringify({ username: username }),
			success: function (sessionResponse, status) {
				console.log(sessionResponse);
				window.session = sessionResponse.session;
				console.log(window.session);
				if (status != "success") {
					console.log("failed!, trying again");
					return getUsername()
				}
			},
			dataType: "json",
			contentType: "application/json"
	  });
	}
	getUsername();
});
</script>
]]

return function()
  ngx.header["content-type"] = "text/html"
  ngx.say(html)
end