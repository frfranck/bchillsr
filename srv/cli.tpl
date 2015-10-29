<html>
<head>
<title>Chill test client</title>
<link href="./static/css/style.css" rel="stylesheet" type="text/css" />
   
<script src="https://maps.googleapis.com/maps/api/js"></script>
<script src="./static/js/jquery.1.6.4.min.js"></script>
<script src="./static/js/smartgoogleapi.js"></script>

<script>
	$(document).ready(function() {
			
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
			if( tokens[5] != 'PBAD' ) {
				if( tokens[1]=='dh1' )
					$('#dashboard').append("<tr> <td>a123 ready</td> <td>"+tokens[5]+"</td> <td></td> <td>"+tokens[6]+"/"+tokens[7]+"</td> </tr>");
				else if( tokens[1]=='dh2' )
					$('#dashboard').append("<tr> <td>a123 ready</td> <td></td> <td>"+tokens[5]+"</td> <td>"+tokens[6]+"/"+tokens[7]+"</td> </tr>");
				
				if( tokens[5]=='P2' ) 
					setTimeout(function(){ ws.send("cis1:dh1:airb1:a123:H:PBAD:blocked:24000"); }, 5000);
			}
			else {
				if( tokens[1]=='dh1' )
					$('#dashboard').append("<tr> <td>a123 ready</td> <td>blocked</td> <td></td> <td>"+tokens[6]+"/"+tokens[7]+"</td> </tr>");
				else if( tokens[1]=='dh2' )
					$('#dashboard').append("<tr> <td>a123 ready</td> <td></td> <td>blocked</td> <td>"+tokens[6]+"/"+tokens[7]+"</td> </tr>");
			}
		  }

		  ws.onclose = function () {
			setTimeout(function () {
			// Connection has closed so try to reconnect every 10 seconds.
			createWebSocket(); 
			}, 10*1000);
		  }
	   }
	   createWebSocket();
	   $('#dashboard').append("<tr> <td>a123 ready</td> <td></td> <td></td> <td></td> </tr>");
	   GoogleMapMgr.map_initialize();
	});
</script>

</head>
<body>
	<div id="map"></div>
	<input type=button onclick="GoogleMapMgr.start()" value="Start"/>
	<input type=button onclick="GoogleMapMgr.triggerAlert()" value="Trigger Alert"/>
	<input type=button onclick="GoogleMapMgr.reset()" value="Reset"/>
	<table id="dashboard">
		<tr> <th><h2>Cisco</h2></th> <th><h2>Exp1</h2></th> <th><h2>Exp2</h2></th> <th><h2>Delivery</h2></th> </tr>
	</table>
	<div id="div_messages"></div>
</body>
</html>