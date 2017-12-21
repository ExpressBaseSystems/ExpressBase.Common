CREATE UNIQUE INDEX eb_objects_id_idx
    ON public.eb_objects USING btree
    (id)
    TABLESPACE pg_default;
	
--.........................................
CREATE UNIQUE INDEX eb_objects_relations_id_idx
    ON public.eb_objects_relations USING btree
    (id)
    TABLESPACE pg_default;
	
--........................................
CREATE UNIQUE INDEX eb_objects_status_id_idx
    ON public.eb_objects_status USING btree
    (id)
    TABLESPACE pg_default;
	
--.......................................
CREATE INDEX eb_objects_ver_eb_objects_id_idx
    ON public.eb_objects_ver USING btree
    (eb_objects_id)
    TABLESPACE pg_default;
	
--......................................
CREATE UNIQUE INDEX eb_applications_id_idx
    ON public.eb_applications USING btree
    (id)
    TABLESPACE pg_default;