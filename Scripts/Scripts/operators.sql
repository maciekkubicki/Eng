--Insert jsonb 18798
CREATE TABLE temp_time (id int, t1 timestamp, t2 timestamp);
INSERT INTO temp_time (id, t1, t2) VALUES (1, clock_timestamp(), clock_timestamp());
\i 'C:/Users/MaciekKubicki/Desktop/PracaInzynierska/GetJSON/GetJSON/person_insert_jsonb.sql'
UPDATE temp_time SET t2=clock_timestamp() WHERE id=1;
SELECT t2-t1 FROM temp_time WHERE id=1;
DROP TABLE temp_time;
--Insert json 18798--
CREATE TABLE temp_time (id int, t1 timestamp, t2 timestamp);
INSERT INTO temp_time (id, t1, t2) VALUES (1, clock_timestamp(), clock_timestamp());
\i 'C:/Users/MaciekKubicki/Desktop/PracaInzynierska/GetJSON/GetJSON/person_insert_json.sql'
UPDATE temp_time SET t2=clock_timestamp() WHERE id=1;
SELECT t2-t1 FROM temp_time WHERE id=1;
DROP TABLE temp_time;



SET CLIENT_ENCODING TO 'UTF-8';
SELECT max(cast(data->'person'->>'personID' AS int)) FROM personjsonb; -----Z2  ***
SELECT max((data->'person'->'personID' AS int) FROM personjsonb; --1
SELECT "ObjectID", data->'person'->>'LastName' AS Surname FROM personjsonb WHERE data->'person'->>'LastName' LIKE 'T%' LIMIT 5; --1***
SELECT data #> '{person,LastName}' AS NAME, COUNT(*) FROM public.personjsonb GROUP BY NAME; --Z3 ***
SELECT "ObjectID",jsonb_pretty(data) FROM public.personjsonb;
SELECT count(data) FROM public.personjsonb WHERE jsonb_array_length(data->'email')=2; --1
SELECT data->'email'->0 AS FirstEmail FROM public.personjsonb WHERE jsonb_array_length(data->'email')=1 LIMIT 3; --Z4
SELECT count(data) FROM public.personjsonb WHERE jsonb_array_length(data->'email')=0; --specjalnie - nigdzie nie ma pustej tablicy, bo nie ma key email--

SELECT count(data) FROM public.personjsonb WHERE data ? 'email'; --Z1 Not
SELECT count(d.data)-(SELECT count(dd.data) FROM public.personjsonb dd where dd.data ? 'email') FROM public.personjsonb d; --ile osób nie ma maila?-- --2
SELECT jsonb_each(data) FROM public.personjsonb WHERE "ObjectID"=192119; --3
SELECT jsonb_each(data->'person') FROM public.personjsonb WHERE "ObjectID"=192119; --3
SELECT jsonb_each_text(data->'address') FROM public.personjsonb WHERE "ObjectID"=192119; --3
SELECT count(data) FROM public.personjsonb WHERE data ? 'email'; --Z1 Not
SELECT count(data) FROM public.personjsonb WHERE data ?| array['person','address','email']; --Z2
SELECT count(data) FROM public.personjsonb WHERE data ?& array['person','address','email']; --Z3
SELECT jsonb_pretty(data #- '{"address","postal_code"}') FROM public.personjsonb WHERE "ObjectID"=192119; --2
SELECT count(data) FROM public.personjsonb WHERE data->'address' @> '{"city":"Bellevue"}'; --2
SELECT count(data) FROM public.personjsonb WHERE data->'address'->>'city'='Bellevue'; --1/2

SELECT DISTINCT data->'address'->'city' AS City FROM personjsonb ORDER BY City ASC; --1
SELECT jsonb_pretty(data) FROM public.personjsonb WHERE "ObjectID"=192119; --3
SELECT jsonb_pretty(data-'address') FROM public.personjsonb WHERE "ObjectID"=192119;
SELECT jsonb_pretty(data #- '{"address","postal_code"}') FROM public.personjsonb WHERE "ObjectID"=192119; --2
SELECT jsonb_pretty(data->'email') FROM public.personjsonb WHERE "ObjectID"=192119;
SELECT jsonb_pretty(data->'email' #- '{1}') FROM public.personjsonb WHERE "ObjectID"=192119;
SELECT jsonb_pretty(data->'email' #- '{0}') FROM public.personjsonb WHERE "ObjectID"=192119;--ujemne indeksowanie--
SELECT jsonb_pretty(data->'email' #- '{0}' || '["newmail@hotmail.com"]'::jsonob) FROM public.personjsonb WHERE "ObjectID"=192119;

BEGIN TRANSACTION;
UPDATE public.personjsonb SET data = (SELECT data #- '{"email"}' || '{"email": ["newmail@hotmail.com"]}'::jsonb  FROM public.personjsonb WHERE "ObjectID"=1922) WHERE "ObjectID"=1922;
SELECT jsonb_pretty(data) FROM public.personjsonb WHERE "ObjectID"=1922;
ROLLBACK;



BEGIN TRANSACTION;
SELECT count(data) FROM public.personjsonb where data ? 'email';
UPDATE public.personjsonb d SET data = (SELECT data || ('{"email":[' || quote_ident(dd.data->'person'->>'LastName'||'@hotmail.com')||']}')::jsonb  FROM public.personjsonb dd  WHERE d."ObjectID"=dd."ObjectID") WHERE not d.data ? 'email'; --***
SELECT count(data) FROM public.personjsonb where data ? 'email';
ROLLBACK;
SELECT data-'email' FROM public.personjsonb WHERE "ObjectID" = 192119; 

'{"email":[' || quote_ident(data->'person'->>'LastName'||'@hotmail.com')||']}' from public.personjsonb;


--4
--CREATE FUNCTIONS
SELECT to_jsonb(Name) FROM Users;
SELECT to_jsonb(date) FROM Users;
SELECT to_jsonb(ARRAY(SELECT Name From Users));
SELECT array_to_json(ARRAY(SELECT idUsers From Users));
SELECT row_to_json(row1,true) FROM (SELECT idUsers,username, Name, Surname, mail FROM Users WHERE idUsers=2) row1;
SELECT row_to_json(row,true) FROM (SELECT username, Name, Surname,  mail FROM Users WHERE idUsers=2) row;
SELECT ARRAY[Id::text, Code::text, Name::text] AS my_arr FROM tbl;
SELECT json_build_array(row)FROM (SELECT username, Name, Surname, date, mail FROM Users where idUsers=2) row;
SELECT json_build_array(ARRAY(SELECT Name From Users), ARRAY(SELECT idUsers From Users));
SELECT json_build_array(ARRAY(SELECT username, Name, Surname, date, mail FROM Users));
SELECT json_build_array(array_cat(ARRAY(SELECT Name From Users), ARRAY(SELECT idUsers From Users)));
SELECT jsonb_pretty(jsonb_build_object('FirstName',Name,'LastName',Surname,'City',Town,'ID', idUsers)) FROM Users;--tu lepiej bo id to liczba
SELECT ARRAY(jsonb_build_object('FirstName',Name,'LastName',Surname,'City',Town,'ID', idUsers)) FROM Users;
SELECT jsonb_pretty(jsonb_object(ARRAY['FirstName','LastName','City','ID'],ARRAY[Name::text, Surname::text, Town::text,idUsers::text])) FROM Users;
select * from jsonb_build_array(SELECT jsonb_build_object('FirstName',Name,'LastName',Surname,'City',Town,'ID', idUsers) FROM Users);
--PROCESSING FUNCTIONS
--insert / set
--jsonb_array_lenght
--jsonb_pretty
--jsonb_each  __text
--json_extract_path #>
--json_extract_path_text #>>
SELECT jsonb_object_keys(data) FROM personjsonb WHERE "ObjectID" = 192119; 
SELECT jsonb_object_keys(data->'person') FROM personjsonb WHERE "ObjectID" = 1921;
create type temp_person AS ("LastName" varchar(25), "personID" int, "FirstName" varchar(25), "MiddleName" varchar(25));
SELECT (jsonb_populate_record(null::temp_person,  data->'person')).* from personjsonb;
SELECT jsonb_array_elements(data->'email') from personjsonb;
--jsonb_array_elements_text
SELECT jsonb_typeof(data) AS Document, jsonb_typeof(data->'email') AS Email_Array, jsonb_typeof(data->'person'->'personID') AS PersonID, jsonb_typeof(data->'email'->0) AS Email, jsonb_typeof('true') AS Bool, jsonb_typeof('null') AS Null FROM personjsonb LIMIT 1;
SELECT jsonb_to_record(data->'person') as x("LastName" varchar(25), "personID" int, "FirstName" varchar(25), "MiddleName" varchar(25));

select count(data) from personjsonb where (cast(data->'person'->>'personID' as int))>=18000;
begin transaction;
delete from personjsonb where (cast(data->'person'->>'personID' as int))>=18000;
rollback;


BEGIN TRANSACTION;
SELECT jsonb_pretty(data) FROM public.personjsonb WHERE "ObjectID"=1922;
UPDATE public.personjsonb SET data = (SELECT jsonb_set(data,'{email,1}','"newmail@hotmail.com"',false) FROM public.personjsonb WHERE "ObjectID"=1922) WHERE "ObjectID"=1922;
SELECT jsonb_pretty(data) FROM public.personjsonb WHERE "ObjectID"=1922;
ROLLBACK;






SELECT max(cast(data->'person'->>'personID' AS int)) FROM personjsonb;
SELECT data #> '{person,LastName}' AS NAME, COUNT(*) FROM public.personjsonb GROUP BY NAME;
SELECT count(data) FROM public.personjsonb WHERE data ? 'email';
SELECT "ObjectID", data->'person'->>'LastName' AS Surname FROM personjsonb WHERE data->'person'->>'LastName' LIKE 'T%';