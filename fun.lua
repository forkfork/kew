local html = [[


<!DOCTYPE html>
<html lang="en" >

<head>

  <meta charset="UTF-8">
  <link rel="shortcut icon" type="image/x-icon" href="https://static.codepen.io/assets/favicon/favicon-8ea04875e70c4b0bb41da869e81236e54394d63638a1ef12fa558a4a835f1164.ico" />
  <link rel="mask-icon" type="" href="https://static.codepen.io/assets/favicon/logo-pin-f2d2b6d2c61838f7e76325261b7195c27224080bc099486ddd6dccb469b8e8e6.svg" color="#111" />
  <meta name="robots" content="noindex">
  <title>CodePen - Hello, WebRTC on Safari 11</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/meyer-reset/2.0/reset.min.css">

  
      <style>
      html, body{
  height: 100%;
  overflow: hidden;
  width: 100%;
}

video{
  left: 0px;
  position: absolute;
  transform: translate(-0%, -0%);
  top: 0px;
	height:200px;
}
    </style>

  
  
  
  

</head>

<body translate="no" >

  
  
  
  

    <script >
      navigator.getUserMedia  = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia;

var video = document.createElement('video');
video.style.width =  document.width + 'px';
video.style.height = document.height + 'px';
video.setAttribute('autoplay', '');
video.setAttribute('muted', '');
video.setAttribute('playsinline', '');

var facingMode = "user";

var constraints = {
  audio: false,
  video: {
    facingMode: facingMode
  }
}

navigator.mediaDevices.getUserMedia(constraints).then(function success(stream) {
  video.srcObject = stream;
});

document.body.appendChild(video);

video.addEventListener('click', function() {
  if (facingMode == "user") {
    facingMode = "environment";
  } else {
    facingMode = "user";
  }
  
  constraints = {
    audio: false,
    video: {
      facingMode: facingMode
    }
  }  
  
  navigator.mediaDevices.getUserMedia(constraints).then(function success(stream) {
    video.srcObject = stream;  
  });
});

function takePhoto() {
  console.log('Taking photo!');
	//var canvas = document.createElement('canvas');
	var canvas = document.getElementById("paint");
	var ctx = canvas.getContext('2d');
	canvas.width = video.videoWidth;
	canvas.height = video.videoHeight;
	ctx.drawImage(video, 0, 0, video.videoWidth, video.videoHeight);
	const data = canvas.toDataURL('image/jpeg');
	window.photo = data;
}
    </script>



   <canvas id="paint"></canvas>
<button onClick="takePhoto()">📸</button>
  

</body>

</html>
 
]]

return function()
  ngx.header["content-type"] = "text/html"
  ngx.say(html)
end
