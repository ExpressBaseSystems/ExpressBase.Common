﻿using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Constants
{
    public static class SqlFiles
    {
        public static readonly string[] SQLSCRIPTS = {"eb_compilefunctions.sql",
                        "eb_extras.sql",
                        "datadb.functioncreate.eb_authenticate_anonymous.sql",
                        "datadb.functioncreate.eb_authenticate_unified.sql",
                        "datadb.functioncreate.eb_create_or_update_rbac_roles.sql",
                        "datadb.functioncreate.eb_create_or_update_role.sql",
                        "datadb.functioncreate.eb_create_or_update_role2loc.sql",
                        "datadb.functioncreate.eb_create_or_update_role2role.sql",
                        "datadb.functioncreate.eb_create_or_update_role2user.sql",
                        "datadb.functioncreate.eb_currval.sql",
                        "datadb.functioncreate.eb_getpermissions.sql",
                        "datadb.functioncreate.eb_getroles.sql",
                        "datadb.functioncreate.eb_persist_currval.sql",
                        "datadb.functioncreate.eb_revokedbaccess2user.sql",
                        "datadb.functioncreate.eb_security_user.sql",
                        "datadb.functioncreate.eb_security_usergroup.sql",
                        "datadb.functioncreate.eb_security_constraints.sql",
                        "datadb.tablecreate.eb_audit_lines.sql",
                        "datadb.tablecreate.eb_audit_master.sql",
                        "datadb.tablecreate.eb_constraints_line.sql",
                        "datadb.tablecreate.eb_constraints_master.sql",
                        "datadb.tablecreate.eb_files_ref.sql",
                        "datadb.tablecreate.eb_files_ref_variations.sql",
                        "datadb.tablecreate.eb_keys.sql",
                        "datadb.tablecreate.eb_keyvalue.sql",
                        "datadb.tablecreate.eb_languages.sql",
                        "datadb.tablecreate.eb_query_choices.sql",
                        "datadb.tablecreate.eb_role2location.sql",
                        "datadb.tablecreate.eb_role2permission.sql",
                        "datadb.tablecreate.eb_role2role.sql",
                        "datadb.tablecreate.eb_role2user.sql",
                        "datadb.tablecreate.eb_roles.sql",
                        "datadb.tablecreate.eb_schedules.sql",
                        "datadb.tablecreate.eb_signin_log.sql",
                        "datadb.tablecreate.eb_surveys.sql",
                        "datadb.tablecreate.eb_survey_lines.sql",
                        "datadb.tablecreate.eb_survey_master.sql",
                        "datadb.tablecreate.eb_survey_queries.sql",
                        "datadb.tablecreate.eb_user2usergroup.sql",
                        "datadb.tablecreate.eb_useranonymous.sql",
                        "datadb.tablecreate.eb_usergroup.sql",
                        "datadb.tablecreate.eb_users.sql",
                        "datadb.tablecreate.eb_userstatus.sql",
                        "filesdb.tablecreate.eb_files_bytea.sql",
                        "objectsdb.functioncreate.eb_botdetails.sql",
                        "objectsdb.functioncreate.eb_createbot.sql",
                        "objectsdb.functioncreate.eb_get_tagged_object.sql",
                        "objectsdb.functioncreate.eb_objects_change_status.sql",
                        "objectsdb.functioncreate.eb_objects_commit.sql",
                        "objectsdb.functioncreate.eb_objects_create_new_object.sql",
                        "objectsdb.functioncreate.eb_objects_exploreobject.sql",
                        "objectsdb.functioncreate.eb_objects_getversiontoopen.sql",
                        "objectsdb.functioncreate.eb_objects_save.sql",
                        "objectsdb.functioncreate.eb_objects_update_dashboard.sql",
                        "objectsdb.functioncreate.eb_object_create_major_version.sql",
                        "objectsdb.functioncreate.eb_object_create_minor_version.sql",
                        "objectsdb.functioncreate.eb_object_create_patch_version.sql",
                        "objectsdb.functioncreate.eb_split_str_util.sql",
                        "objectsdb.functioncreate.eb_str_to_tbl_util.sql",
                        "objectsdb.tablecreate.eb_applications.sql",
                        "objectsdb.tablecreate.eb_bots.sql",
                        "objectsdb.tablecreate.eb_executionlogs.sql",
                        "objectsdb.tablecreate.eb_google_map.sql",
                        "objectsdb.tablecreate.eb_locations.sql",
                        "objectsdb.tablecreate.eb_location_config.sql",
                        "objectsdb.tablecreate.eb_objects.sql",
                        "objectsdb.tablecreate.eb_objects2application.sql",
                        "objectsdb.tablecreate.eb_objects_favourites.sql",
                        "objectsdb.tablecreate.eb_objects_relations.sql",
                        "objectsdb.tablecreate.eb_objects_status.sql",
                        "objectsdb.tablecreate.eb_objects_ver.sql" } ;
    }
}
