---JSONB
SELECT max(cast(data->'person'->>'personID' AS int)) FROM personjsonb;
SELECT data #> '{person,LastName}' AS NAME, COUNT(*) FROM public.personjsonb GROUP BY NAME;
SELECT data FROM public.personjsonb WHERE data ? 'email';
SELECT "ObjectID", data->'person'->>'LastName' AS Surname FROM personjsonb WHERE data->'person'->>'LastName' LIKE 'T%' AND jsonb_array_length(data->'email')=2;
UPDATE public.personjsonb d SET data = (SELECT data || ('{"email":[' || quote_ident(dd.data->'person'->>'LastName'||'@hotmail.com')||']}')::jsonb  FROM public.personjsonb dd  WHERE d."ObjectID"=dd."ObjectID") WHERE not d.data ? 'email';
delete from personjsonb where (cast(data->'person'->>'personID' as int))>=18000;


---JSON
SELECT max(cast(data->'person'->>'personID' AS int)) FROM personjson;
SELECT data->'person'->>'LastName' AS NAME, COUNT(*) FROM public.personjson GROUP BY NAME;
SELECT data FROM public.personjson WHERE data::jsonb ? 'email';
SELECT "ObjectID", data->'person'->>'LastName' AS Surname FROM personjson WHERE data->'person'->>'LastName' LIKE 'T%' AND json_array_length(data->'email')=2;
UPDATE public.personjson d SET data = (SELECT data::jsonb || ('{"email":[' || quote_ident(dd.data->'person'->>'LastName'||'@hotmail.com')||']}')::jsonb  FROM public.personjson dd  WHERE d."ObjectID"=dd."ObjectID")::json WHERE not d.data::jsonb ? 'email';
delete from personjson where (cast(data->'person'->>'personID' as int))>=18000;

---MONGO

db.person_col.find({},{"person.personID":1}).sort({"person.personID": -1}).limit(1).explain("executionStats");--39

db.person_col.aggregate([{"$group" : {_id:"$person.LastName", count:{$sum:1}}}]);--56

db.person_col.find({ "email": { $exists: true, $ne: null} }).explain("executionStats");--21
db.person_col.find({"person.LastName": /T.*/, "email": {$size: 2 }},{"person.LastName":1}).pretty().explain("executionStats");--18

var t1 = new Date()
db.person_col.find({"email": { $exists: null, $ne: true}}).snapshot().forEach( function (elem) {db.person_col.update(  { _id: elem._id },      { $set:        	{  'email': [ elem.LastName +'@new.com']  }});});
var t2 = new Date()
t2-t1 --4685

var t1 = new Date()
db.person_col.remove({$where: "this.person.personID >= 18000"});
var t2 = new Date()
t2-t1 --946
---COUCHBASE
SELECT max(person.personID) FROM `Person_Bucket`;
SELECT person.LastName, count(person.LastName) FROM `Person_Bucket` GROUP BY person.LastName;
SELECT data FROM `Person_Bucket` WHERE email IS NOT MISSING;
SELECT person.LastName FROM `Person_Bucket` WHERE person.LastName LIKE 'T%' AND ARRAY_COUNT(email)=2;
UPDATE `Person_Bucket` i SET i.email = [i.person.LastName||'@new.pl'] WHERE email IS MISSING;
DELETE FROM `Person_Bucket` WHERE person.personID >= 18000;