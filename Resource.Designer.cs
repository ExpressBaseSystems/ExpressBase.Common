﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.42000
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ExpressBase.Common {
    using System;
    using System.Reflection;
    
    
    /// <summary>
    ///    A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    public class Resource {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        internal Resource() {
        }
        
        /// <summary>
        ///    Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        public static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("ExpressBase.Common.Resource", typeof(Resource).GetTypeInfo().Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///    Overrides the current thread's CurrentUICulture property for all
        ///    resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        public static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///    Looks up a localized string similar to  -- Table: public.eb_objects
        ///
        ///CREATE SEQUENCE IF NOT EXISTS eb_objects_id_seq START 1;
        ///CREATE TABLE public.eb_objects
        ///(
        ///    id integer NOT NULL DEFAULT nextval(&apos;eb_objects_id_seq&apos;::regclass),
        ///    obj_name text COLLATE pg_catalog.&quot;default&quot;,
        ///    obj_desc text COLLATE pg_catalog.&quot;default&quot;,
        ///    obj_type integer,
        ///    obj_last_ver_id integer,
        ///    obj_cur_status integer,
        ///    CONSTRAINT eb_objects_pkey PRIMARY KEY (id)
        ///)
        ///WITH (
        ///    OIDS = FALSE
        ///)
        ///TABLESPACE pg_default;
        ///
        ///ALTER TABLE public.eb_object [rest of string was truncated]&quot;;.
        /// </summary>
        public static string postgres_eb_objects {
            get {
                return ResourceManager.GetString("postgres_eb_objects", resourceCulture);
            }
        }
        
        /// <summary>
        ///    Looks up a localized string similar to  CREATE SEQUENCE IF NOT EXISTS eb_users_id_seq START 1;
        ///--Table: public.eb_users
        ///
        ///CREATE TABLE IF NOT EXISTS public.eb_users
        ///(
        ///    id integer NOT NULL DEFAULT nextval(&apos;eb_users_id_seq&apos;::regclass),
        ///    email text COLLATE pg_catalog.&quot;default&quot;,
        ///    pwd text COLLATE pg_catalog.&quot;default&quot;,
        ///    eb_del boolean DEFAULT false,
        ///    firstname text COLLATE pg_catalog.&quot;default&quot;,
        ///    lastname text COLLATE pg_catalog.&quot;default&quot;,
        ///    middlename text COLLATE pg_catalog.&quot;default&quot;,
        ///    dob date,
        ///    phnoprimary text [rest of string was truncated]&quot;;.
        /// </summary>
        public static string postgres_eb_users {
            get {
                return ResourceManager.GetString("postgres_eb_users", resourceCulture);
            }
        }
    }
}