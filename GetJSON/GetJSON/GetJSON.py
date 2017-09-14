from DatabasePrepartion import *
import pyodbc 
import couchdb
import calendar
import psycopg2
from test import *
from datetime import datetime
from couchbase.bucket import Bucket
from couchbase.exceptions import CouchbaseError
from plotS import *


def prepere_json():

	cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER=localhost\SQLEXPRESS;DATABASE=AdventureWorks2008;')
	cursor = cnxn.cursor()
	cursor.execute("SELECT e.EmailAddress, pp.FirstName, ISNULL(pp.MiddleName,'') AS MiddleName, pp.LastName, p.BusinessEntityID,[AddressLine1],ISNULL([AddressLine2],'') AS AddressLine2,[City],[PostalCode] FROM [AdventureWorks2008].[Person].[Address] a,[AdventureWorks2008].[Person].[EmailAddress] e, [AdventureWorks2008].[Person].[BusinessEntityAddress] p, [AdventureWorks2008].[Person].[Person] pp WHERE p.AddressID = a.AddressID and pp.BusinessEntityID=p.BusinessEntityID and e.BusinessEntityID=pp.BusinessEntityID;")
	rows = cursor.fetchall()
	with open('person.json','w') as pl:
		for row in rows:
			if is_json(to_json(row) ):
				pl.write(to_json(row,False)+'\n')

	with open('person_insert_json.sql','w') as pl:
		for row in rows:
			if is_json(to_json(row) ):
				pl.write(to_insert(to_json(row),'personjson')+'\n')	


	with open('person_insert_jsonb.sql','w') as pl:
		for row in rows:
			if is_json(to_json(row) ):
				pl.write(to_insert(to_json(row),'personjsonb')+'\n')	
	to_doc('person.json')
	insert_couchbase(Bucket('couchbase://localhost/Person_Bucket'), "person.json")

def to_doc(fName):
	with open(fName) as fp:
		for doc in fp:
			id = uuid.uuid4()
			f = open("Person_Bucket/doc/" + str(id) + ".json","w")
			f.write(doc)
			f.close()

#insert_couchbase(Bucket('couchbase://localhost/Person_Bucket'), "person.json")

#to_doc("person.json")
#prepere_json()
test1()
plotAll()
##test2()
#plotIndex()
