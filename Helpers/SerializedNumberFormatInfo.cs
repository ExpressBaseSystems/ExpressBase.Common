using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;

namespace ExpressBase.Common.Helpers
{
    public class SerializedNumberFormatInfo
    {
        public void PopulateFromCultureInfo(CultureInfo Culture)
        {
            this.CurrencyDecimalDigits = Culture.NumberFormat.CurrencyDecimalDigits;
            this.CurrencyDecimalSeparator = Culture.NumberFormat.CurrencyDecimalSeparator;
            this.CurrencyGroupSeparator = Culture.NumberFormat.CurrencyGroupSeparator;
            this.CurrencyGroupSizes = Culture.NumberFormat.CurrencyGroupSizes;
            this.CurrencyNegativePattern = Culture.NumberFormat.CurrencyNegativePattern;
            this.CurrencyPositivePattern = Culture.NumberFormat.CurrencyPositivePattern;
            this.CurrencySymbol = Culture.NumberFormat.CurrencySymbol;
            this.DigitSubstitution = Culture.NumberFormat.DigitSubstitution;
            this.NaNSymbol = Culture.NumberFormat.NaNSymbol;
            this.NativeDigits = Culture.NumberFormat.NativeDigits;
            this.NegativeInfinitySymbol = Culture.NumberFormat.NegativeInfinitySymbol;
            this.NegativeSign = Culture.NumberFormat.NegativeSign;
            this.NumberDecimalDigits = Culture.NumberFormat.NumberDecimalDigits;
            this.NumberDecimalSeparator = Culture.NumberFormat.NumberDecimalSeparator;
            this.NumberGroupSeparator = Culture.NumberFormat.NumberGroupSeparator;
            this.NumberGroupSizes = Culture.NumberFormat.NumberGroupSizes;
            this.NumberNegativePattern = Culture.NumberFormat.NumberNegativePattern;
            this.PercentDecimalDigits = Culture.NumberFormat.PercentDecimalDigits;
            this.PercentDecimalSeparator = Culture.NumberFormat.PercentDecimalSeparator;
            this.PercentGroupSeparator = Culture.NumberFormat.PercentGroupSeparator;
            this.PercentGroupSizes = Culture.NumberFormat.PercentGroupSizes;
            this.PercentNegativePattern = Culture.NumberFormat.PercentNegativePattern;
            this.PercentPositivePattern = Culture.NumberFormat.PercentPositivePattern;
            this.PercentSymbol = Culture.NumberFormat.PercentSymbol;
            this.PerMilleSymbol = Culture.NumberFormat.PerMilleSymbol;
            this.PositiveInfinitySymbol = Culture.NumberFormat.PositiveInfinitySymbol;
            this.PositiveSign = Culture.NumberFormat.PositiveSign;
        }
        public void PopulateIntoCultureInfo(CultureInfo Culture)
        {
            Culture.NumberFormat.CurrencyDecimalDigits = this.CurrencyDecimalDigits;
            Culture.NumberFormat.CurrencyDecimalSeparator = this.CurrencyDecimalSeparator;
            Culture.NumberFormat.CurrencyGroupSeparator = this.CurrencyGroupSeparator;
            Culture.NumberFormat.CurrencyGroupSizes = this.CurrencyGroupSizes;
            Culture.NumberFormat.CurrencyNegativePattern = this.CurrencyNegativePattern;
            Culture.NumberFormat.CurrencyPositivePattern = this.CurrencyPositivePattern;
            Culture.NumberFormat.CurrencySymbol = this.CurrencySymbol;
            Culture.NumberFormat.DigitSubstitution = this.DigitSubstitution;
            Culture.NumberFormat.NaNSymbol = this.NaNSymbol;
            Culture.NumberFormat.NativeDigits = this.NativeDigits;
            Culture.NumberFormat.NegativeInfinitySymbol = this.NegativeInfinitySymbol;
            Culture.NumberFormat.NegativeSign = this.NegativeSign;
            Culture.NumberFormat.NumberDecimalDigits = this.NumberDecimalDigits;
            Culture.NumberFormat.NumberDecimalSeparator = this.NumberDecimalSeparator;
            Culture.NumberFormat.NumberGroupSeparator = this.NumberGroupSeparator;
            Culture.NumberFormat.NumberGroupSizes = this.NumberGroupSizes;
            Culture.NumberFormat.NumberNegativePattern = this.NumberNegativePattern;
            Culture.NumberFormat.PercentDecimalDigits = this.PercentDecimalDigits;
            Culture.NumberFormat.PercentDecimalSeparator = this.PercentDecimalSeparator;
            Culture.NumberFormat.PercentGroupSeparator = this.PercentGroupSeparator;
            Culture.NumberFormat.PercentGroupSizes = this.PercentGroupSizes;
            Culture.NumberFormat.PercentNegativePattern = this.PercentNegativePattern;
            Culture.NumberFormat.PercentPositivePattern = this.PercentPositivePattern;
            Culture.NumberFormat.PercentSymbol = this.PercentSymbol;
            Culture.NumberFormat.PerMilleSymbol = this.PerMilleSymbol;
            Culture.NumberFormat.PositiveInfinitySymbol = this.PositiveInfinitySymbol;
            Culture.NumberFormat.PositiveSign = this.PositiveSign;
        }
        public int NumberDecimalDigits { get; set; }
        public string NumberDecimalSeparator { get; set; }
        public string NumberGroupSeparator { get; set; }
        public int[] NumberGroupSizes { get; set; }
        public int NumberNegativePattern { get; set; }
        public int PercentDecimalDigits { get; set; }
        public string PercentDecimalSeparator { get; set; }
        public string PercentGroupSeparator { get; set; }
        public int[] PercentGroupSizes { get; set; }
        public int PercentNegativePattern { get; set; }
        public int PercentPositivePattern { get; set; }
        public string PercentSymbol { get; set; }
        public string PerMilleSymbol { get; set; }
        public string NegativeSign { get; set; }
        public string NegativeInfinitySymbol { get; set; }
        public string[] NativeDigits { get; set; }
        public string NaNSymbol { get; set; }
        public DigitShapes DigitSubstitution { get; set; }
        public string CurrencySymbol { get; set; }
        public int CurrencyPositivePattern { get; set; }
        public int CurrencyNegativePattern { get; set; }
        public int[] CurrencyGroupSizes { get; set; }
        public string CurrencyGroupSeparator { get; set; }
        public string CurrencyDecimalSeparator { get; set; }
        public int CurrencyDecimalDigits { get; set; }
        public string PositiveInfinitySymbol { get; set; }
        public string PositiveSign { get; set; }
    }
}
