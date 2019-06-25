CREATE TABLE eb_appstore
(
  id integer NOT NULL auto_increment,
  app_name varchar(100),
  status integer,
  user_tenant_acc_id text,
  cost integer,
  created_by integer,
  created_at timestamp,
  json json,
  eb_del char(1) DEFAULT 'F',
  currency text,
  CONSTRAINT eb_app_store_pkey PRIMARY KEY (id)
);

create index eb_appstore_key on eb_appstore(id) using btree;

create index eb_appstore_app_name_key on eb_appstore(app_name ) using btree;

