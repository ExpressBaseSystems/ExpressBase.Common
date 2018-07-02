-- Table: public.eb_files

-- DROP TABLE eb_files;

CREATE TABLE eb_files
(
    id integer NOT NULL AUTO_iNCREMENT,
    userid integer NOT NULL,
    objid text NOT NULL,
    length bigint,
    tags text,
    bucketname text,
    filetype text,
    uploaddatetime timestamp,
    eb_del1 boolean NOT NULL DEFAULT false,
    eb_del char NOT NULL DEFAULT 'F',
    CONSTRAINT eb_files_pkey PRIMARY KEY (id),
    CONSTRAINT eb_files_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);
-- Index: eb_files_eb_del_idx

-- ALTER TABLE eb_files DROP INDEX eb_files_eb_del_idx;

CREATE INDEX eb_files_eb_del_idx
    ON eb_files(eb_del);

-- Index: eb_files_id_idx

-- ALTER TABLE eb_files DROP INDEX eb_files_id_idx;

CREATE INDEX eb_files_id_idx
    ON eb_files(id);