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
<h1 class="article-title">Publish Messages</h1>
<button id=hobbit class="btn-large" style="width: 60%">Produce a mesage</button>
<br><br>
<div id=content>
</div>
<button id=custom class="btn-large" style="width: 60%">Produce Custom Message</button>
<br><br>
<div id=words>
</div>
<script>
$(document).ready(function() {

var hobbitText = "In a hole in the ground there lived a hobbit. Not a nasty, dirty, wet hole, filled with the ends of worms and an oozy smell, nor yet a dry, bare, sandy hole with nothing in it to sit down on or to eat: it was a hobbit-hole, and that means comfort. It had a perfectly round door like a porthole, painted green, with a shiny yellow brass knob in the exact middle. The door opened on to a tube-shaped hall like a tunnel: a very comfortable tunnel without smoke, with panelled walls, and floors tiled and carpeted, provided with polished chairs, and lots and lots of pegs for hats and coats the hobbit was fond of visitors. The tunnel wound on and on, going fairly but not quite straight into the side of the hill The Hill, as all the people for many miles round called it and many little round doors opened out of it, first on one side and then on another. No going upstairs for the hobbit: bedrooms, bathrooms, cellars, pantries (lots of these), wardrobes (he had whole rooms devoted to clothes), kitchens, dining rooms, all were on the same floor, and indeed on the same passage. The best rooms were all on the left-hand side (going in), for these were the only ones to have windows, deep-set round windows looking over his garden, and meadows beyond, sloping down to the river.".split(" ");
var hobbitIdx = 0;

  function postLorum() {
    if(hobbitIdx >= hobbitText.length) {
      hobbitIdx = 0;
    }
		var message = hobbitText[hobbitIdx++];
    $.ajax({
      type: "POST",
      url: "/postmessage",
      data: JSON.stringify({ message: message }),
      contentType: "application/json"
    });
		var text = $("#words").text();
		$("#words").text(text + " " + message);
  }

  function postCustom() {
    var message = prompt("Write custom message");
    $.ajax({
      type: "POST",
      url: "/postmessage",
      data: JSON.stringify({ message: message }),
      contentType: "application/json"
    });
		var text = $("#words").text();
		$("#words").text(text + " " + message);
  }

  var hobbit = document.getElementById("hobbit");
  var custom = document.getElementById("custom");
  var words = document.getElementById("words");
  hobbit.addEventListener("touchend", function(event) {
    event.preventDefault();
    postLorum();
  });
  hobbit.addEventListener("click", function(event) {
    postLorum();
  });
  custom.addEventListener("click", function(event) {
    postCustom();
  });
});
</script>
]]

return function()
  ngx.header["content-type"] = "text/html"
  ngx.say(html)
end
