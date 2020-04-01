using ExpressBase.Common.Data;
using ExpressBase.Common.Objects;
using ExpressBase.Common.Structures;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;

namespace ExpressBase.Common.Extensions
{
    public static class ListExtensions
    {
        public static IEnumerable Flatten(this IEnumerable enumerable)
        {
            foreach (object element in enumerable)
            {
                IEnumerable candidate = element as IEnumerable;
                if (candidate != null)
                {
                    foreach (object nested in Flatten(candidate))
                        yield return nested;
                }
                else
                    yield return element;
            }
        }
        public static List<Object> PopRange(this List<object> List, int from, int to)
        {
            List<object> items = new List<object>();

            try
            {
                int range = to - from;
                for (int i = from; i < range; i++)
                    items.Add(List[i]);

                List.RemoveRange(from, range);
            }
            catch (Exception e)
            {

            }

            return items;
        }

        public static IEnumerable<EbControl> Get1stLvlControls(this List<EbControl> enumerable)
        {
            foreach (EbControl element in enumerable)
            {
                if (!(element is EbControlContainer))
                    yield return element;
            }
        }

        public static IEnumerable<EbControl> FlattenEbControls(this List<EbControl> enumerable)// get all controls except EbControlContainers
        {
            foreach (EbControl element in enumerable)
            {
                EbControlContainer candidate = element as EbControlContainer;
                if (candidate != null)
                {
                    foreach (EbControl nested in FlattenEbControls(candidate.Controls))
                        yield return nested;
                }
                else
                {
                    yield return element;
                }
            }
        }

        public static EbControl[] FlattenAllEbControls(this List<EbControl> controls)
        {
            List<EbControl> list = new List<EbControl>();
            FlattenAllEbControlsRec(controls, ref list);
            return list.ToArray();
        }

        private static void FlattenAllEbControlsRec(List<EbControl> controls, ref List<EbControl> list)// get all controls including EbControlContainers
        {
            foreach (EbControl control in controls)
            {
                EbControlContainer candidate = control as EbControlContainer;
                if (candidate != null)
                {
                    FlattenAllEbControlsRec(candidate.Controls, ref list);
                }
                list.Add(control);
            }
        }

        public static List<DbParameter> ParamsToDbParameters(this List<Param> Params, EbConnectionFactory factory)
        {
            List<DbParameter> DbParams = new List<DbParameter>();
            foreach (Param p in Params)
            {
                DbParams.Add(factory.DataDB.GetNewParameter(p.Name, (EbDbTypes)Convert.ToInt32(p.Type), p.ValueTo));
            }
            return DbParams;
        }
    }
}
