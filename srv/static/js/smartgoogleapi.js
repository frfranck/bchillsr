
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

var GoogleMapMgr = {
	
	_marker_trucks 		: undefined,
	_marker_alert 		: undefined,
	_map 				: undefined,
	_directionsService 	: undefined,
	_directionsDisplay 	: undefined,

	map_initialize : function() {
		
		GoogleMapMgr._directionsService = new google.maps.DirectionsService;
		GoogleMapMgr._directionsDisplay = new google.maps.DirectionsRenderer;
		var mapCanvas = document.getElementById('map');
		var mapOptions = {
			center: new google.maps.LatLng(48.561486, 2.44604),
			zoom: 11,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}
		GoogleMapMgr._map = new google.maps.Map(mapCanvas, mapOptions);
	},

	calculateAndDisplayRoute : function(directionsService, directionsDisplay, flag) {
		
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
	},

	start : function() {
		
		if( GoogleMapMgr._marker_trucks ) {
			GoogleMapMgr._marker_trucks.setMap(null);
			GoogleMapMgr._marker_trucks = undefined;
		}
		GoogleMapMgr._marker_trucks = new google.maps.Marker({
			position: {lat: 48.611486, lng: 2.30604},
			map: GoogleMapMgr._map,
			icon: "./static/images/truck3.png",
			title: 'Arpajon'
		  });
		GoogleMapMgr._directionsDisplay.setMap(GoogleMapMgr._map);
		GoogleMapMgr.calculateAndDisplayRoute(GoogleMapMgr._directionsService, GoogleMapMgr._directionsDisplay, true);
	},

	triggerAlert : function() {
		
		if( GoogleMapMgr._marker_alert ) {
			GoogleMapMgr._marker_alert.setMap(null);
			GoogleMapMgr._marker_alert = undefined;
		}
		GoogleMapMgr._marker_alert = new google.maps.Marker({
			position: alert_pos,
			map: GoogleMapMgr._map,
			icon: "./static/images/caution.png",
			title: 'Alert'
		});
		//setTimeout( function(){ GoogleMapMgr.calculateAndDisplayRoute(GoogleMapMgr._directionsService, GoogleMapMgr._directionsDisplay, false) }, 2000);
	},

	reset : function() {
		
		if( GoogleMapMgr._marker_trucks ) {
			GoogleMapMgr._marker_trucks.setMap(null);
			GoogleMapMgr._marker_trucks = undefined;
		}
		if( GoogleMapMgr._marker_alert ) {
			GoogleMapMgr._marker_alert.setMap(null);
			GoogleMapMgr._marker_alert = undefined;
		}
		GoogleMapMgr._directionsDisplay.setMap(null);
	}
	
};

