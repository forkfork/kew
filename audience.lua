local html = [[
<script
  src="https://code.jquery.com/jquery-2.2.4.min.js"
	integrity="sha256-BbhdlvQf/xTY9gja0Dq3HiwQF8LaCRTXxZKRutelT44="
	crossorigin="anonymous"></script>
  <link rel="stylesheet" href="https://unpkg.com/papercss@1.4.1/dist/paper.min.css">
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
			data: JSON.stringify({ session: window.session, messageid: window.messageid }),
			success: function(messageResponse, status, xhr) {
			  if (xhr.getResponseHeader("messageid")) {
				  window.messageid = xhr.getResponseHeader("messageid");
				}
				$("#content").append("<h3 class=item>" + messageResponse + "</h3>");
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
	  do {
			var username = prompt("Please choose a username (alphanumeric, max 12 chars)");
		} while (!username);
		$.ajax({
		  type: "POST",
			url: "/createsession",
			data: JSON.stringify({ username: username }),
			success: function (sessionResponse, status) {
				console.log(sessionResponse);
				window.session = sessionResponse.session;
				window.messageid = "0-0";
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
