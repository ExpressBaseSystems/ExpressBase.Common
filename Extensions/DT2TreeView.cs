using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ExpressBase.Common.Extensions
{
    public class Node<T>
    {
        internal Node() { }
        public T Item { get; internal set; }
        public IList<Node<T>> Children { get; internal set; }
    }

    public static class DT2TreeView
    {
        public static IEnumerable<Node<T>> ToHierarchy<T>(
        this IEnumerable<T> source,
        Func<T, bool> startWith,
        Func<T, T, bool> connectBy)
        {
            if (source == null) throw new ArgumentNullException();
            if (startWith == null) throw new ArgumentNullException();
            if (connectBy == null) throw new ArgumentNullException();

            var roots = from item in source
                        where startWith(item)
                        select item;
            foreach (T value in roots)
            {
                var children = new List<Node<T>>();
                var newNode = new Node<T>
                {
                    Item = value,
                    Children = children.AsReadOnly()
                };

                T tmpValue = value;
                children.AddRange(source.ToHierarchy(possibleSub => connectBy(tmpValue, possibleSub), connectBy));

                yield return newNode;
            }
        }
    }

    public static class DTEnumerable
    {
        public static IEnumerable<EbDataRow> AsEnumerable(this EbDataTable source)
        {
            return source.Rows;
        }
    }
}
