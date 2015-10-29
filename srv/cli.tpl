<html>
<head>
<title>Chill test client</title>
<link href="./static/css/style.css" rel="stylesheet" type="text/css" />
   <script src="./static/js/jquery.1.6.4.min.js"></script>
<script>
	$(document).ready(function() {
	
		$('#div_cisco').append('<h2>Cisco</h2>');
		$('#div_exp1').append('<h2>Exp1</h2>');
		$('#div_exp2').append('<h2>Exp2</h2>');
		$('#div_delivery').append('<h2>Delivery</h2>');
		
		if (!window.WebSocket) {
			if (window.MozWebSocket) {
				window.WebSocket = window.MozWebSocket;
			} else {
				$('#div_messages').append("<li>Your browser doesn't support WebSockets.</li>");
			}
		}

		function createWebSocket () {
		  var serverip = location.host;
		  //alert(serverip);
		  var ws = new WebSocket('ws://'+serverip+'/events');
		  ws.onopen = function(evt) {
			console.log('Connected to delivery status queuing pipeline.');
			$('#div_messages').append('<li>Connected to delivery status queuing pipeline.</li>');
		  }
		  ws.onmessage = function(evt) {
			console.log('onmessage(): '+evt.data);
			$('#div_messages').append('<li>' + evt.data + '</li>');
			var tokens = evt.data.split(':');
			$('#div_cisco').append('<li>' + tokens[0] + '</li>');
			if( tokens[1]=="dh1" )
				$('#div_exp1').append('<li>' + tokens[1] + '</li>');
			else if( tokens[1]=="dh2" )
				$('#div_exp2').append('<li>' + tokens[1] + '</li>');
			$('#div_delivery').append('<li>' + tokens[2] + '</li>');
			
		  }

		  ws.onclose = function () {
			setTimeout(function () {
			// Connection has closed so try to reconnect every 10 seconds.
			createWebSocket(); 
			}, 10*1000);
		  }
	   }
	   createWebSocket();
	});
</script>
</head>

</head>
<body>
<div id="div_cisco"></div>
<div id="div_exp1"></div>
<div id="div_exp2"></div>
<div id="div_delivery"></div>
<div id="div_messages"></div>
</body>
</html>