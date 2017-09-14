import sys
import codecs
import pyodbc
import json
import random
import couchdb
import calendar
import uuid

from datetime import datetime
from couchbase.bucket import Bucket
from couchbase.exceptions import CouchbaseError


def to_doc(fName):
	with open(fName) as fp:
		for doc in fp:
			id = uuid.uuid4()
			f = open("doc/" + str(id) + ".json","w")
			f.write(doc)
			f.close()



def insert_couchbase(bucket,fileName):
	with open(fileName) as pl:
		for document in pl:
			
			id = uuid.uuid4()
			doc = json.loads(document)
			bucket.insert( '{}'.format(id), doc)




def is_json(myjson):
  try:
    json_object = json.loads(myjson)
  except ValueError, e:
    return False
  return True

def to_json(row,newLines=True):
	if newLines:
		string = '{ "person": {\n  "personID": ' + str(row.BusinessEntityID) + ',\n "FirstName": "'+ str(row.FirstName.replace(u'\xe8','e').replace(u'\xed','i').replace(u'\xe9','e').replace(u'\xe1','a').replace(u'\xe7','c').replace("'","").encode('utf-8'))+'",\n'
		if row.MiddleName !='':
			string+= '"MiddleName": "'+str(row.MiddleName.replace(u'\xe8','e').replace(u'\xe9','e').replace(u'\xe1','a').replace(u'\xe7','c').replace(u'\xed','i').replace("'","").encode('utf-8'))+'",\n'
		string+= '"LastName": "' + str(row.LastName.replace(u'\xe8','e').replace(u'\xe9','e').replace(u'\xe1','a').replace(u'\xe7','c').replace(u'\xed','i').replace("'","").encode('utf-8')) + '"\n}'
		string += ',\n "address": { \n "city": "'+str(row.City.replace(u'\xe8','e').replace("'","").encode('utf-8'))+'",\n "addres_line1": "'+str((row.AddressLine1).replace(u'\xe8','e').replace("'","").encode('utf-8'))+'",\n'
		if row.AddressLine2 != '':
			string += '"address_line2": "' + str(row.AddressLine2.replace(u'\xb4','').replace("'","")) +'",\n'
		string += '"postal_code": "'+ str(row.PostalCode.replace("'",""))+'"\n}'
		ile = random.choice([0,1,2])
		if ile==0:		    
			string += '\n}'
		elif ile==1:
			string += ',\n "email":["'+str(row.EmailAddress.encode('utf-8'))+'"]}'
		else:
			email = str(row.LastName.replace("'","").encode('utf-8'))+str(row.BusinessEntityID)+"@mail.com"
			string += ',\n "email":["'+str(row.EmailAddress.encode('utf-8'))+'","'+email+'"]}'
		#print string
		#print is_json(string)
		#print type(row)
		return string
	else:
		string = '{ "person": {  "personID": ' + str(row.BusinessEntityID) + ', "FirstName": "'+ str(row.FirstName.replace(u'\xe8','e').replace(u'\xed','i').replace(u'\xe9','e').replace(u'\xe1','a').replace(u'\xe7','c').replace("'","").encode('utf-8'))+'",'
		if row.MiddleName !='':
			string+= '"MiddleName": "'+str(row.MiddleName.replace(u'\xe8','e').replace(u'\xe9','e').replace(u'\xe1','a').replace(u'\xe7','c').replace(u'\xed','i').replace("'","").encode('utf-8'))+'",'
		string+= '"LastName": "' + str(row.LastName.replace(u'\xe8','e').replace(u'\xe9','e').replace(u'\xe1','a').replace(u'\xe7','c').replace(u'\xed','i').replace("'","").encode('utf-8')) + '"}'
		string += ', "address": {  "city": "'+str(row.City.replace(u'\xe8','e').replace("'","").encode('utf-8'))+'", "addres_line1": "'+str((row.AddressLine1).replace(u'\xe8','e').replace("'","").encode('utf-8'))+'",'
		if row.AddressLine2 != '':
			string += '"address_line2": "' + str(row.AddressLine2.replace(u'\xb4','').replace("'","")) +'",'
		string += '"postal_code": "'+ str(row.PostalCode.replace("'",""))+'"}'
		ile = random.choice([0,1,2])
		if ile==0:		    
			string += '}'
		elif ile==1:
			string += ', "email":["'+str(row.EmailAddress.encode('utf-8'))+'"]}'
		else:
			email = str(row.LastName.replace("'","").encode('utf-8'))+str(row.BusinessEntityID)+"@mail.com"
			string += ', "email":["'+str(row.EmailAddress.encode('utf-8'))+'","'+email+'"]}'
		#print string
		#print is_json(string)
		#print type(row)
		return string

	
def to_insert(json,tabName):
	string = 'INSERT INTO '+str(tabName) +'(data) VALUES (\''+json+'\');' 
	return string
	
