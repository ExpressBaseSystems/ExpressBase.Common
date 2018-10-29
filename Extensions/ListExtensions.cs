﻿using ExpressBase.Common.Objects;
using System;
using System.Collections;
using System.Collections.Generic;
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

        public static IEnumerable<EbControl> FlattenAllEbControls(this List<EbControl> enumerable)// get all controls including EbControlContainers
        {
            foreach (EbControl element in enumerable)
            {
                EbControlContainer candidate = element as EbControlContainer;
                if (candidate != null)
                {
                    candidate.Controls.FlattenAllEbControls();
                }
                yield return element;
            }
        }
    }
}
