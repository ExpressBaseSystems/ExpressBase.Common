using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ExpressBase.Common.Extensions
{
    public class TreeData<T>
    {
        public List<Node<T>> Tree { set; get; }

        public List<EbDataRow> RowsOrdered { set; get; }

        public TreeData()
        {
            RowsOrdered = new RowColletion();
            Tree = new List<Node<T>>();
        }
    }

    public class Node<T>
    {
        internal Node() { }

        public T Item { get; internal set; }

        public int Level { get; internal set; }

        public IList<Node<T>> Children { get; internal set; }

        public bool IsGroup { set; get; }
    }

    public static class DT2TreeView
    {
        public static TreeData<T> ToTree<T>(
        this IEnumerable<T> source,
        Func<T, bool> startWith,
        Func<T, T, bool> connectBy,
        string group)
        {
            if (source == null) throw new ArgumentNullException("source");
            if (startWith == null) throw new ArgumentNullException("startWith");
            if (connectBy == null) throw new ArgumentNullException("connectBy");

            List<int> Proc = new List<int>();
            TreeData<T> treedata = new TreeData<T>();
            treedata.Tree = source.ToTree(startWith, connectBy, null, Proc, treedata.RowsOrdered, group).ToList<Node<T>>();
            return treedata;
        }

        private static IEnumerable<Node<T>> ToTree<T>(
            this IEnumerable<T> source,
            Func<T, bool> startWith,
            Func<T, T, bool> connectBy,
            Node<T> parent,
            List<int> proc,
            List<EbDataRow> RowsOrdered,
            string group)
        {
            int level = (parent == null ? 0 : parent.Level + 1);

            var roots = from item in source
                        where startWith(item)
                        select item;
            foreach (T value in roots)
            {
                var children = new List<Node<T>>();
                var id = Convert.ToInt32((value as EbDataRow)["id"]);
                if (!proc.Contains(id))
                {
                    proc.Add(id);
                    var newNode = new Node<T>
                    {
                        Level = level,
                        Item = value,
                        IsGroup = Convert.ToString((value as EbDataRow)[group]) == "T" || (bool.TryParse(Convert.ToString((value as EbDataRow)[group]), out bool bvalout) == true && bvalout),
                        Children = children.AsReadOnly()
                    };

                    RowsOrdered.Add(value as EbDataRow);

                    T tmpValue = value;
                    children.AddRange(source.ToTree(possibleSub => connectBy(tmpValue, possibleSub), connectBy, newNode, proc, RowsOrdered, group));

                    yield return newNode;
                }
            }
        }
    }

    public static class DTEnumerable
    {
        public static IEnumerable<EbDataRow> Enumerate(this EbDataTable source)
        {
            return source.Rows;
        }
    }
}
