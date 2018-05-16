--COMPILE FUNCTIONS

BEGIN

    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_authenticate_unified COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_create_or_update_role2role COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_create_or_update_role2user COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_getroles COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_permissions COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_authenticate_anonymous COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_create_or_update_rbac_roles COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_create_or_update_role COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_createormodifyuserandroles COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_objects_getversiontoopen COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_get_tagged_object COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_object_create_major_version COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_object_create_minor_version COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_object_create_patch_version COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_objects_change_status COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_objects_commit COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_objects_create_new_object COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_objects_exploreobject COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_objects_save COMPILE';
    EXECUTE IMMEDIATE 'ALTER FUNCTION eb_objects_update_dashboard COMPILE';

END;