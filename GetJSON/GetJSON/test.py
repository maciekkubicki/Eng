import sys
import codecs
import pyodbc
import json
import random
import couchdb
import calendar
import uuid
import psycopg2
from datetime import datetime
from couchbase.bucket import Bucket
from couchbase.exceptions import CouchbaseError
from couchbase.n1ql import N1QLQuery
from DatabasePrepartion import *
import time
from pymongo import *


query1 = []
query1.append("SELECT max(cast(data->'person'->>'personID' AS int)) FROM personjsonb;")
query1.append("SELECT data #> '{person,LastName}' AS NAME, COUNT(*) FROM public.personjsonb GROUP BY NAME;");
query1.append("SELECT count(data) FROM public.personjsonb WHERE data ? 'email';");
query1.append("SELECT \"ObjectID\", data->'person'->>'LastName' AS Surname FROM personjsonb WHERE data->'person'->>'LastName' LIKE 'T%' AND jsonb_array_length(data->'email')=2;");
query1.append("UPDATE public.personjsonb d SET data = (SELECT data || ('{\"email\":[' || quote_ident(dd.data->'person'->>'LastName'||'@hotmail.com')||']}')::jsonb  FROM public.personjsonb dd  WHERE d.\"ObjectID\"=dd.\"ObjectID\") WHERE not d.data ? 'email';");
query1.append("delete from personjsonb where (cast(data->'person'->>'personID' as int))>=18000;");
query2 = []
query2.append("SELECT max(cast(data->'person'->>'personID' AS int)) FROM personjson;")
query2.append("SELECT data->'person'->>'LastName' AS NAME, COUNT(*) FROM public.personjson GROUP BY NAME;")
query2.append("SELECT count(data) FROM public.personjson WHERE data::jsonb ? 'email';")
query2.append("SELECT \"ObjectID\", data->'person'->>'LastName' AS Surname FROM personjson WHERE data->'person'->>'LastName' LIKE 'T%' AND json_array_length(data->'email')=2;")
query2.append("UPDATE public.personjson d SET data = (SELECT data::jsonb || ('{\"email\":[' || quote_ident(dd.data->'person'->>'LastName'||'@hotmail.com')||']}')::jsonb  FROM public.personjson dd  WHERE d.\"ObjectID\"=dd.\"ObjectID\")::json WHERE not d.data::jsonb ? 'email';")
query2.append("delete from personjson where (cast(data->'person'->>'personID' as int))>=18000;")
query3 = []
query3.append("SELECT max(person.personID) FROM `Person_Bucket`;")
query3.append("SELECT person.LastName, count(person.LastName) FROM `Person_Bucket` GROUP BY person.LastName;")
query3.append("SELECT count(*) FROM `Person_Bucket` WHERE email IS NOT MISSING;")
query3.append("SELECT person.LastName FROM `Person_Bucket` WHERE person.LastName LIKE 'T%' AND ARRAY_COUNT(email)=2;")
query3.append("UPDATE `Person_Bucket` i SET i.email = [i.person.LastName||'@new.pl'] WHERE email IS MISSING;")
query3.append("DELETE FROM `Person_Bucket` WHERE person.personID >= 18000;")
#10,136
#6,536
#36,8
#4.236
def test1():
	mongo = []
	postgres1 = []
	postgres2 = []
	couchbase = []
	
	c=MongoClient()
	conn1 = psycopg2.connect(database="Inz", user="postgres", password="1260221", host="127.0.0.1", port="5433")
	cur1 = conn1.cursor()
	conn2 = Bucket('couchbase://localhost/Person_Bucket')
	
	mongo.append(0.598)
	postgres1.append(15.455)
	postgres2.append(15.073)
	couchbase.append(16.722)

	for i in range(6):
		t0 = time.time()
		cur1.execute(query1[i])
		if(i>=4): conn1.commit()
		t1 = time.time()
		postgres1.append(t1-t0)
				
		t0 = time.time()
		cur1.execute(query2[i])
		if(i>=4): conn1.commit()
		t1 = time.time()
		postgres2.append(t1-t0)

		t0 = time.time()
		q=N1QLQuery(query3[i])
		conn2.n1ql_query(q).execute()
		t1 = time.time()
		couchbase.append(t1-t0)

		
	postgres1.append(10.136)
	postgres2.append(6.536)
	couchbase.append(10.7)
	mongo.append(0.039)
	mongo.append(0.056)
	mongo.append(0.021)
	mongo.append(0.018)
	mongo.append(4.685)
	mongo.append(0.946)
	mongo.append(4.236)


	f=open('test.dat', "w")
	f.write(str(postgres1)+"\n"+str(postgres2)+"\n"+str(couchbase)+"\n"+str(mongo)+"\n")
	f.close()


def test2():
	
	t = []
	query = "SELECT \"ObjectID\", data->'person'->>'LastName'::text AS Surname FROM personjsonb WHERE data->'person'->>'LastName'::text LIKE 'T%';"
	query_c = "CREATE INDEX surname on personjsonb (((data->'person'->>'LastName')::text));"
	query_d = "DROP INDEX surname"
	conn1 = psycopg2.connect(database="Inz", user="postgres", password="1260221", host="127.0.0.1", port="5433")
	cur1 = conn1.cursor()
	t0 = time.time()
	for i in range(10):
		cur1.execute(query)
	t1 = time.time()
	t.append((t1-t0)/10)
	cur1.execute(query_c)
	conn1.commit()
	t0 = time.time()
	for i in range(10):
		cur1.execute(query)
	t1 = time.time()
	t.append((t1-t0)/10)
	f=open('test2.dat', "w")
	f.write(str(t)+"\n")
	f.close()
	cur1.execute(query_d)
	conn1.commit()





