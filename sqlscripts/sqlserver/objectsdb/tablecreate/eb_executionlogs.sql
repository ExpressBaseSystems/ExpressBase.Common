CREATE SEQUENCE eb_executionlogs_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_executionlogs
(
    id int default (NEXT VALUE FOR eb_executionlogs_id_seq),
    rows varchar(max),
    exec_time integer,
    created_by integer,
    created_at datetime,
    refid varchar(max),
    params nvarchar(max),
    CONSTRAINT eb_executionlogs_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_executionlogs_id_idx 
ON eb_executionlogs(id);
