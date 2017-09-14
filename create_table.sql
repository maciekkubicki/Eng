CREATE TABLE tab1 (
  idAddress SERIAL   NOT NULL ,
  data JSONB NOT NULL,
PRIMARY KEY(idAddress));

SELECT "idAddress", data FROM public.tab1;


CREATE TABLE public.tab2
(
    "idAddress" serial NOT NULL,
    data json NOT NULL,
    PRIMARY KEY ("idAddress")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.tab2
    OWNER to postgres;