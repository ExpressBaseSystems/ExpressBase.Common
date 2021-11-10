CREATE SEQUENCE eb_role2user_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_role2user
(
    id int default(NEXT VALUE FOR eb_role2user_id_seq) primary key,
    role_id int,
    user_id int,
    createdby int,
    createdat datetime2(6),
    revokedby int,
    revokedat datetime2(6),
    eb_del "char" NOT NULL DEFAULT 'F',
    CONSTRAINT eb_role2user_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
)

CREATE INDEX eb_role2user_id_idx ON eb_role2user(id);
CREATE INDEX eb_role2user_role_id_idx ON eb_role2user(role_id);
CREATE INDEX eb_role2user_eb_del_idx ON eb_role2user(eb_del);
CREATE INDEX eb_role2user_user_id_idx ON eb_role2user(user_id);