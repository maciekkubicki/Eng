CREATE TABLE PersonJSONB (
  "ObjectID" SERIAL   NOT NULL ,
  data JSONB NOT NULL,
PRIMARY KEY("ObjectID"));
CREATE TABLE PersonJSON(
  "ObjectID" serial NOT NULL,
  data JSON NOT NULL,
  PRIMARY KEY ("ObjectID"));
  
\i 'C:/Users/MaciekKubicki/Desktop/PracaInzynierska/GetJSON/GetJSON/person_insert_json.sql'
\i 'C:/Users/MaciekKubicki/Desktop/PracaInzynierska/GetJSON/GetJSON/person_insert_jsonb.sql'

CREATE TABLE Users (
  idUsers SERIAL   NOT NULL ,
  username VARCHAR(20)   NOT NULL ,
  password VARCHAR(255)   NOT NULL ,
  mail VARCHAR(255)   NOT NULL ,
  Name VARCHAR   NOT NULL ,
  Surname VARCHAR   NOT NULL ,
  town VARCHAR(20)   NOT NULL ,
  gender Gender   NOT NULL ,
  country VARCHAR(255) NOT NULL,
  date timestamp   NOT NULL ,
PRIMARY KEY(idUsers));

\i 'C:/Users/MaciekKubicki/Desktop/PracaInzynierska/GetJSON/GetJSON/populate_users.sql'