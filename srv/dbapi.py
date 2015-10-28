import sqlite3, sys, traceback
from pprint import pprint

CreateDataBase = sqlite3.connect('chill-1.db')
CreateDataBase.row_factory = sqlite3.Row

QueryCurs = CreateDataBase.cursor()

def CreateTable():

    try:
        QueryCurs.execute('''
        	              CREATE TABLE Users (
                            id INTEGER PRIMARY KEY autoincrement,
                            name TEXT unique,
                            last_update INTEGER(4) DEFAULT (strftime('%s','now')))''')

        QueryCurs.execute('''CREATE TABLE Devices
                         (id INTEGER PRIMARY KEY autoincrement,
                          name TEXT unique,
                          userid INTEGER NOT NULL,
                          last_update INTEGER(4) DEFAULT (strftime('%s','now')),
                          FOREIGN KEY(userid) REFERENCES Users(id))''')
    except:
        traceback.print_exc(file=sys.stdout)

def AddUser(username):
    QueryCurs.execute('''INSERT INTO Users(name)
    VALUES (?)''',[username])

def AddDevice(device,username):
    record=None
    try:
        QueryCurs.execute('select * from Users where name="'+username+'"')
        record=QueryCurs.fetchone()
    except:
        traceback.print_exc(file=sys.stdout)
    if not record is None:
        QueryCurs.execute('''INSERT INTO Devices (name,userid)
                             VALUES (?,?)''',(device,record['id']))

CreateTable()
CreateDataBase.commit()

AddUser("longjoe1")
AddUser('joe2')
AddUser('joe3')
CreateDataBase.commit()

AddDevice('device1-1','longjoe1')
AddDevice('device1-3','longjoe1')
AddDevice('device1-2','longjoe1')
AddDevice('device2-1','joe2')
AddDevice('device3-1','joe3')
#AddEntry('Bill','Rue 2','Fourmies','Nord',105.2)

CreateDataBase.commit()
