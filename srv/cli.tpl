<html>
<head>
<title>Chill test client</title>
<link href="./static/css/style.css" rel="stylesheet" type="text/css" />
   
<script src="./static/js/jquery.1.6.4.min.js"></script>


<script src="https://maps.googleapis.com/maps/api/js"></script>
<script>
	var marker_trucks;
	var marker_alert;
	var map;
	var directionsService;
	var directionsDisplay;
	/*var positions = [ 	{lat: 48.589172, lng: 2.246237},
						{lat: 48.611486, lng: 2.30604},
						{lat: 48.6102599, lng: 2.474805},
						{lat: 48.542105, lng: 2.6554}];*/
	var positions = [ 	{lat: 48.589172, lng: 2.246237},
						{lat: 48.625287, lng: 2.314425},
						{lat: 48.626169, lng: 2.47673},
						{lat: 48.542105, lng: 2.6554}];
	var positions_alert = [ 	{lat: 48.589172, lng: 2.246237},
						{lat: 48.625287, lng: 2.314425},
							{lat: 48.505983, lng: 2.60788},
						{lat: 48.542105, lng: 2.6554}];
	var positions2 = [ 	{lat: 48.589172, lng: 2.246237},
							{lat: 48.598897, lng: 2.245846},
							{lat: 48.625228, lng: 2.262325},
							{lat: 48.621824, lng: 2.276402},
						{lat: 48.625287, lng: 2.314425},
						{lat: 48.626169, lng: 2.47673},
						{lat: 48.542105, lng: 2.6554}];
	var alert_pos = {lat: 48.631683, lng: 2.535095};
	function map_initialize() {
		directionsService = new google.maps.DirectionsService;
		directionsDisplay = new google.maps.DirectionsRenderer;
		var mapCanvas = document.getElementById('map');
		var mapOptions = {
			center: new google.maps.LatLng(48.561486, 2.44604),
			zoom: 11,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}
		map = new google.maps.Map(mapCanvas, mapOptions);
				
	}
	
	function calculateAndDisplayRoute(directionsService, directionsDisplay, flag) {
		var waypts = [];
		if( flag )
			for (var i = 1; i < positions.length-1; i++) {
				waypts.push({
					location: new google.maps.LatLng(positions[i].lat,positions[i].lng),
					stopover: true
				});
			}
		else 
			for (var i = 1; i < positions_alert.length-1; i++) {
				waypts.push({
					location: new google.maps.LatLng(positions_alert[i].lat,positions_alert[i].lng),
					stopover: (i==2)?false:true
				});
			}
			
		directionsService.route({
			origin: new google.maps.LatLng(positions[0].lat,positions[0].lng),
			destination: new google.maps.LatLng(positions[3].lat,positions[3].lng),
			waypoints: waypts,
			optimizeWaypoints: true,
			travelMode: google.maps.TravelMode.DRIVING
		  }, function(response, status) {
			if (status === google.maps.DirectionsStatus.OK) {
			  directionsDisplay.setDirections(response);
			  var route = response.routes[0];
			} else {
			  window.alert('Directions request failed due to ' + status);
			}
		});
	}
	
	function start() {
		marker_trucks = new google.maps.Marker({
			position: {lat: 48.611486, lng: 2.30604},
			map: map,
			icon: "./static/images/truck3.png",
			title: 'Arpajon'
		  });
		directionsDisplay.setMap(map);
		calculateAndDisplayRoute(directionsService, directionsDisplay, true);
	}
	
	function triggerAlert() {
		marker_alert = new google.maps.Marker({
			position: alert_pos,
			map: map,
			icon: "./static/images/caution.png",
			title: 'Alert'
		});
		setTimeout( function(){ calculateAndDisplayRoute(directionsService, directionsDisplay, false) }, 2000);
	}
	
	function reset() {
		if( marker_trucks ) {
			marker_trucks.setMap(null);
			marker_trucks = undefined;
		}
		if( marker_alert ) {
			marker_alert.setMap(null);
			marker_alert = undefined;
		}
		directionsDisplay.setMap(null);
	}
</script>

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
	   map_initialize();
	});
</script>

</head>
<body>
<div id="map"></div>
<input type=button onclick="start()" value="Start"/>
<input type=button onclick="triggerAlert()" value="Trigger Alert"/>
<input type=button onclick="reset()" value="Reset"/>
<table id="dashboard">
<tr> <th><h2>Cisco</h2></th> <th><h2>Exp1</h2></th> <th><h2>Exp2</h2></th> <th><h2>Delivery</h2></th> </tr>
</table>
<div id="div_messages"></div>
</body>
</html>