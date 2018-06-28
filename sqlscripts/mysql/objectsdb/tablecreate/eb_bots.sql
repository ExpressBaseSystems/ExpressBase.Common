-- Table: eb_bots

-- DROP TABLE eb_bots;

CREATE TABLE eb_bots
(
    id integer NOT NULL AUTO_INCREMENT,
    name text,
    url text,
    welcome_msg text,
    botid VARCHAR(100),
    modified_by integer,
    solution_id integer,
    created_at timestamp,
    modified_at timestamp,
    created_by integer,
    app_id integer,
    fullname text,
    CONSTRAINT eb_bots_pkey PRIMARY KEY (id),
    CONSTRAINT botid_uniquekey UNIQUE (botid)
);

-- Index: eb_bots_app_id_idx

-- DROP INDEX eb_bots_app_id_idx;

CREATE INDEX eb_bots_app_id_idx
    ON eb_bots(app_id);

-- Index: eb_bots_id_idx

-- DROP INDEX eb_bots_id_idx;

CREATE INDEX eb_bots_id_idx
    ON eb_bots(id);