curl http://127.0.0.1:5984/
curl -X PUT http://127.0.0.1:5984/Person_Bucket
curl -X GET http://127.0.0.1:5984/_all_dbs
curl -X GET http://127.0.0.1:5984/inz/_all_docs
curl -w "@C:\Users\MaciekKubicki\Desktop\Praca Inżynierska\curl-format.txt" --dump-header -H "Accept:application/json" -H "Content-Type: application/json" -X POST http://localhost:5984/inz/_find  -d "{\"selector\": {\"_id\": {\"$gt\": null}}}" 

D:\"Program Files"\Couchbase\Server\bin\cbdocloader localhost:8091 -u Administrator -p 1260221 -b Person_Bucket C:\Users\MaciekKubicki\Desktop\PracaInzynierska\GetJSON\GetJSON\Person_Bucket.zip
CREATE PRIMARY INDEX `person_index` ON `Person_Bucket` USING VIEW;
SELECT * FROM `Person_Bucket`;
SELECT count(person) FROM `Person_Bucket`;
SELECT DISTINCT person.LastName, count(person.LastName) FROM `Person_Bucket` GROUP BY person.LastName;
SELECT DISTINCT address.city AS City FROM `Person_Bucket` ORDER BY City ASC;
SELECT person.LastName FROM `Person_Bucket` WHERE person.LastName LIKE 'T%';
SELECT person, address FROM `Person_Bucket` WHERE email IS MISSING;
SELECT person, address FROM `Person_Bucket` WHERE email IS NOT MISSING;
SELECT person, address, email FROM `Person_Bucket` WHERE address.city = "Bellevue";
SELECT person, address, email FROM `Person_Bucket` WHERE ARRAY_COUNT(email)=1;
SELECT person, address, email FROM `Person_Bucket` WHERE ARRAY_COUNT(email)=2;
UPDATE `Person_Bucket` i SET a.email = ['aaa'] FOR a IN Person_Bucket END WHERE email IS MISSING LIMIT 2 RETURNING i;

select * from `Person_Bucket` where person.personID =  18339;
update `Person_Bucket` i set i.email = ['a'] where person.personID = 18339;
UPDATE `Person_Bucket` i set i.email = [i.person.LastName||'@new.pl'] WHERE email IS MISSING LIMIT 3 RETURNING i;
DELETE FROM `Person_Bucket` WHERE person.personID >= 18000;
SELECT * FROM `Person_Bucket` WHERE person.personID >= 18000;
DELETE FROM `Person_Bucket` WHERE person.personID >= 18000;

    CREATE INDEX Index1
    ON `Person_Bucket`(person.LastName) USING GSI;
