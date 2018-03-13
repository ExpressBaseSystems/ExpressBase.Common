//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Threading.Tasks;
//using ExpressBase.Common;
//using ExpressBase.Data;
//using ExpressBase.Security;

//namespace ExpressBase.Security
//{
//    public class Objects : RBACBase

//    {
//        private int _id;
//        private string _name;

//        public int Id
//        {
//            get { return _id; }
//            private set { _id = value; }
//        }

//        public string Name
//        {
//            get { return _name; }
//            private set { _name = value; }
//        }
//        public Objects(int id, string name)
//        {
//            this.Id = id;
//            this.Name = name;
//        }

//        public static Objects Create(string objectname)
//        {
//            var dt = df.DoQuery(string.Format(df.INSERT_EB_OBJECTS, objectname));
//            return new Objects(Convert.ToInt32(dt.Rows[0][0]), objectname);
//        }

//        public static void Delet(int object_id)
//        {
//            string sql = string.Format(df.DELETE_OBJ_FROM_EB_OBJECTS, object_id);
//            sql += string.Format(df.DELETE_OBJ_FROM_EB_PERMISSIONS, object_id);
//            sql += string.Format(df.DELETE_OBJ_FROM_EB_PERMISSION2ROLE, object_id);
//            df.DoQuery(sql);
//        }
//    }
//}

       

    

