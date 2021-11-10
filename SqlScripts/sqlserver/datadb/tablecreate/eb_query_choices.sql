CREATE SEQUENCE eb_query_choices_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_query_choices
(
    id int default(NEXT VALUE FOR eb_query_choices_id_seq) primary key,
    q_id int,
    choice varchar(max),
    eb_del char DEFAULT 'F',
    score int
);

CREATE INDEX eb_query_choices_id_idx ON eb_query_choices(id);