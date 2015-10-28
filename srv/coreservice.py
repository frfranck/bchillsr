import bottle
from bottle import get, run, template, request, response, static_file, error
from bottle import route, install, hook, HTTPError, HTTPResponse
from bottle.ext.websocket import GeventWebSocketServer
from bottle.ext.websocket import websocket

## Simple sqlite 3 orm
#from bottle_peewee import PeeweePlugin
#from peewee import Model, CharField, IntegerField
#from playhouse.shortcuts import *

import json,os,sys
import time
from pprint import pprint


app = bottle.app()

DB_FILE = "chill-1.db"
SERVER_ADDRESS = "0.0.0.0"
SERVER_PORT=8080

## websocket variable
wsusers = set()

rootDir=os.path.dirname(os.path.abspath(__file__))
print rootDir
print "joe"
class var_dump:
       def __init__ (self, PrintableClass):
           for name in dir(PrintableClass):
               value = getattr(PrintableClass,name)
               if  '_' not in str(name).join(str(value)):
                    print '  .%s: %r' % (name, value)

#######################################################################################
## PLUGIN
def Enable_Cors(fn):
    def _Enable_Cors(*args, **kwargs):
        # set CORS headers
        response.headers['Content-Type'] = 'application/json'
        response.headers['Access-Control-Allow-Origin'] = '*'
        response.headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, OPTIONS'
        response.headers['Access-Control-Allow-Headers'] = 'Origin, Accept, Content-Type, X-Requested-With, X-CSRF-Token'
        if request.method != 'OPTIONS':
            # actual request; reply with the actual response
            return fn(*args, **kwargs)
    return _Enable_Cors
##########################################################################################


##------------------------------
## Load default html service
##------------------------------
@app.route('/',method='GET')
def index():
    response.headers['Content-type'] = 'text/html'
    return template('portalbasic')

##------------------------------
## Serve static resources
##------------------------------
@app.route('/static/<filepath:path>', method='GET')
def server_static(filepath):
    return static_file(filepath, root=rootDir+'/static')

##------------------------------
## Service health
##------------------------------
@app.route('/ping',method='GET')
def pong():
    return  '{ "code": 200, "status": "pong" }'




##------------------------------
## Custom error
##------------------------------
@error(500)
@Enable_Cors
def error500(error):
    return  '{ "code": 500, "status": "internal error" }'


@error(400)
@Enable_Cors
def error400(error):
    return  '{ "code": 400, "status": "bad request" }'

@error(404)
@Enable_Cors
def error404(error):
    return  '{ "code": 404, "status": "resource not found" }'

@error(409)
@Enable_Cors
def error409(error):
    return  '{ "code": 409, "status": "resource already exists" }'




##------------------------------
## Specific section for websocket
##------------------------------
## shall be put or post method
##curl  --header "Content-Type:application/json" -X PUT -d '{"status": "done","delay": 0}' http://127.0.0.1:8080/api/event/cisc1/dh1/airb1/a123/done/0

@app.route('/api/event/<prod>/<supp>/<rcv>/<cmdid>/<priority>/<location>/<status>/<delay>',method='PUT')
@Enable_Cors
def serversideevent(prod='none',supp='none',rcv='none',cmdid='none',priority='none',location='none',  status='none',delay='0'):
    for u in wsusers:
        msg = prod + ':' + supp + ':' + rcv + ':' + cmdid + ':'+priority+ ':'+ location + ':' + status + ';' + delay
        u.send(msg)

# websocket method
@app.route('/events', method='GET', apply=[websocket])
@Enable_Cors
def dispatchevent(ws):
    wsusers.add(ws)
    while True:
        msg = ws.receive()
        if msg is not None:
            for u in wsusers:
                u.send(msg)
        else: break
    wsusers.remove(ws)





##------------------------------
## Run the serbices
##------------------------------
app.run(host=SERVER_ADDRESS, port=SERVER_PORT, debug=True, reloader=True, server=GeventWebSocketServer)