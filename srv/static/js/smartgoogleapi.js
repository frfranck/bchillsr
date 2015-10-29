
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
var positions_alert = [ {lat: 48.589172, lng: 2.246237},
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

