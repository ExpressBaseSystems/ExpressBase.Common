using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Security.Core
{
    public class EbPermissions
    {
        public int _id { get; set; }

        public int _object_id { get; set; }

        public int _operation_id { get; set; }

        public string _permissionname { get; set; }

        public EbPermissions(int id, int object_id, int operation_id)
        {
            this._id = id;
            this._object_id = object_id;
            this._operation_id = operation_id;
        }

    }
}
