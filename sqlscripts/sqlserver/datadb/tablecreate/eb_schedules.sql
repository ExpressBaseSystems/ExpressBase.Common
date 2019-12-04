CREATE SEQUENCE eb_schedules_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_schedules
(
    id int default(NEXT VALUE FOR eb_schedules_id_seq) primary key,
    task nvarchar(max),
    created_by int,
    created_at datetime2(6),
    eb_del char,
    jobkey varchar(max),
    triggerkey varchar(max) ,
    status numeric,
    obj_id numeric,
    name varchar(max) 
);

CREATE INDEX eb_schedules_id_idx ON eb_schedules(id);