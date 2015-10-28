<!doctype html>
<head>
    <meta charset="utf-8" />
    <title>WebSocket Chat</title>

    <style>
        li { list-style: none; }
    </style>

    <script src="static/js/jquery.1.6.4.min.js"></script>
    <script>
        $(document).ready(function() {
            if (!window.WebSocket) {
                if (window.MozWebSocket) {
                    window.WebSocket = window.MozWebSocket;
                } else {
                    $('#messages').append("<li>Your browser doesn't support WebSockets.</li>");
                }
            }
            
            function createWebSocket () {
              var serverip = location.host;
              //alert(serverip);
              var ws = new WebSocket('ws://'+serverip+'/events');
              ws.onopen = function(evt) {
                $('#messages').append('<li>Connected to delivery status queuing pipeline.</li>');
              }
              ws.onmessage = function(evt) {
                $('#messages').append('<li>' + evt.data + '</li>');
              }

              ws.onclose = function () {
                setTimeout(function () {
                // Connection has closed so try to reconnect every 10 seconds.
                createWebSocket(); 
                }, 10*1000);
              }

             $('#send-event').submit(function() {
                eventstr = $('#prod').val()
                eventstr += ": " + $('#suppl').val()
                eventstr += ": " + $('#receiver').val()
                eventstr += ": " + $('#cmdid').val()
                eventstr += ": " + $('#priority').val()
                eventstr += ": " + $('#status').val()
                eventstr += ": " + $('#delay').val()
                ws.send(eventstr);
                $('#message').val('').focus();
                return false;
             });
           }
           createWebSocket();
        });
    </script>
</head>
<body>
    <h2>Delivery Status basic portal</h2>
    <form id="send-event">
        <input id="prod" type="text" value="Cis1">
        <input id="suppl" type="text" value="dh1">
        <input id="receiver" type="text" value="airb1">
        <input id="cmdid" type="text" value="a123" />
        <input id="priority" type="text" value="H" size="2"/>
        <input id="status" type="text" value="progress" size="5" />
        <input id="delay" type="text" value="6000" size="4" />
        <input type="submit" value="Send" />
    </form>
    <div id="messages"></div>
</body>
</html>