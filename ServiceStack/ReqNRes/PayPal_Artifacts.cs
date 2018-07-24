using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Enums;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Common.ServiceStack.ReqNRes
{
    [DataContract]
    public class PayPalPaymentRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public string Test { get; set; }
    }

    [DataContract]
    public class PayPalPaymentResponse : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public string Test { get; set; }
    }

    [DataContract(Name ="billing_agreement_response")]
    public class BillingAgreementResponse
    {
        [DataMember(Name ="id")]
        public string Id { get; set; }

        [DataMember(Name ="state")]
        public string AgreementState { get; set; }

        [DataMember(Name ="name")]
        public string Name { get; set; }

        [DataMember(Name ="description")]
        public string Description { get; set; }

        [DataMember(Name ="start_date")]
        public string StartDate { get; set; }

        [DataMember(Name ="agreement_details")]
        public AgreementDetails Details { get; set; }

        [DataMember(Name ="payer")]
        public PayerDetails Payer { get; set; }

        [DataMember(Name ="overrride_merchant_preferences")]
        public MerchantPreferences OverrideMerchantPreferences { get; set; }

        [DataMember(Name ="override_charge_models")]
        public List<ChargeModel> OverrideChargeModels { get; set; }

        [DataMember(Name ="plan")]
        public BillingPlanResponse AgreementPlan { get; set; }

        [DataMember(Name ="links")]
        public List<LinkDescription> Links { get; set; }
    }

    [DataContract(Name = "billing_agreement")]
    public class BillingAgreementRequest
    {
        private string _name;
        private string _description;
        private string _startDate;
        private AgreementDetails _agreementDetails;
        private PayerDetails _payer;
        private BillingPlanResponse _billingPlan;

        [DataMember(Name = "name")]
        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get { return _description; }
            set { _description = value; }
        }

        [DataMember(Name = "start_date")]
        public string StartDate
        {
            get { return _startDate; }
            set { _startDate = value; }
        }

        [DataMember(Name = "agreement_details")]
        public AgreementDetails Details
        {
            get { return _agreementDetails; }
            set { _agreementDetails = value; }
        }

        [DataMember(Name = "payer")]
        public PayerDetails Payer
        {
            get { return _payer; }
            set { _payer = value; }
        }

        [DataMember(Name = "plan")]
        public BillingPlanResponse BillingPlan
        {
            get { return _billingPlan; }
            set { _billingPlan = value; }
        }
    }

    [DataContract(Name = "payer")]
    public class PayerDetails
    {
        private string _paymentMethod;
        private List<FundingInstrument> _fundingInstruments;
        private string _fundingOptionId;

        public static string[] PaymentMethodsStrings = { "bank", "paypal" };

        [DataMember(Name = "payment_method")]
        public string PayMethod
        {
            get { return _paymentMethod; }
            set { _paymentMethod = value; }
        }

        [DataMember(Name = "funding_instruments")]
        public List<FundingInstrument> FundingInstruments
        {
            get { return _fundingInstruments; }
            set { _fundingInstruments = value; }
        }

        [DataMember(Name = "funding_option_id")]
        public string FundingOptionId
        {
            get { return _fundingOptionId; }
            set { _fundingOptionId = value; }
        }
    }

    [DataContract(Name = "funding_instruments")]
    public class FundingInstrument
    {
        private CreditCard _cardDetails;

        [DataMember(Name = "credit_card")]
        public CreditCard CardDetails
        {
            get { return _cardDetails; }
            set { _cardDetails = value; }
        }
    }

    [DataContract(Name = "credit_card")]
    public class CreditCard
    {
        private string _cardId;
        private string _cardNumber;
        private string _cardType;
        private int _expireMonth;
        private int _expireYear;
        private int _cvv2;
        private string _firstName;
        private string _lastName;
        private string _externalCustomerId;
        private CardState _state;
        private string _validUntil;

        [DataMember(Name = "id")]
        public string CardId
        {
            get { return _cardId; }
            set { _cardId = value; }
        }

        [DataMember(Name = "number")]
        public string CardNumber
        {
            get { return _cardNumber; }
            set { _cardNumber = value; }
        }

        [DataMember(Name = "type")]
        public string CardType
        {
            get { return _cardType; }
            set { _cardType = value; }
        }

        [DataMember(Name = "expire_month")]
        public int ExpireMonth
        {
            get { return _expireMonth; }
            set { _expireMonth = value; }
        }

        [DataMember(Name = "expire_year")]
        public int ExpireYear
        {
            get { return _expireYear; }
            set { _expireYear = value; }
        }

        [DataMember(Name = "cvv2")]
        public int Cvv2
        {
            get { return _cvv2; }
            set { _cvv2 = value; }
        }

        [DataMember(Name = "first_name")]
        public string FirstName
        {
            get { return _firstName; }
            set { _firstName = value; }
        }

        [DataMember(Name = "last_name")]
        public string LastName
        {
            get { return _lastName; }
            set { _lastName = value; }
        }

        [DataMember(Name = "external_customer_id")]
        public string ExternalCustomerId
        {
            get { return _externalCustomerId; }
            set { _externalCustomerId = value; }
        }

        [DataMember(Name = "state")]
        public CardState State
        {
            get { return _state; }
            set { _state = value; }
        }

        [DataMember(Name = "valid_until")]
        public string ValidUntil
        {
            get { return _validUntil; }
            set { _validUntil = value; }
        }
    }

    [DataContract(Name = "agreement_details")]
    public class AgreementDetails
    {
        private Currency _outstandingBalance;
        private string _cyclesRemaining;
        private string _cyclesCompleted;
        private string _nextBillingDate;
        private string _lastPaymentDate;
        private Currency _lastPaymentAmount;
        private string _finalPaymentDate;
        private string _failedPaymentCount;

        [DataMember(Name = "outstanding_balance")]
        public Currency OutstandingBalance
        {
            get { return _outstandingBalance; }
            set { _outstandingBalance = value; }
        }

        [DataMember(Name = "cycles_remaining")]
        public string CyclesRemaining
        {
            get { return _cyclesRemaining; }
            set { _cyclesRemaining = value; }
        }

        [DataMember(Name = "cycles_completed")]
        public string CyclesCompleted
        {
            get { return _cyclesCompleted; }
            set { _cyclesCompleted = value; }
        }

        [DataMember(Name = "next_billing_date")]
        public string NextBillingDate
        {
            get { return _nextBillingDate; }
            set { _nextBillingDate = value; }
        }

        [DataMember(Name = "last_payment_date")]
        public string LastPaymentDate
        {
            get { return _lastPaymentDate; }
            set { _lastPaymentDate = value; }
        }

        [DataMember(Name = "last_payment_amount")]
        public Currency LastPaymentAmount
        {
            get { return _lastPaymentAmount; }
            set { _lastPaymentAmount = value; }
        }

        [DataMember(Name = "final_payment_date")]
        public string FinalPaymentDate
        {
            get { return _finalPaymentDate; }
            set { _finalPaymentDate = value; }
        }

        [DataMember(Name = "failed_payment_count")]
        public string FailedPaymentCount
        {
            get { return _failedPaymentCount; }
            set { _failedPaymentCount = value; }
        }
    }

    [DataContract(Name = "payment_plan_response")]
    public class BillingPlanResponse
    {
        private string _planId;
        private string _planName;
        private string _planDesc;
        private string _type;
        private string _state;
        private string _createTime;
        private string _updateTime;
        private List<PaymentDefinition> _paymentDefinitions = new List<PaymentDefinition>();
        private List<Terms> _paymentTerms = new List<Terms>();
        private MerchantPreferences _merchantPref = new MerchantPreferences();
        private Currency _currencyCode;
        private List<LinkDescription> _links;

        public BillingPlanResponse()
        { }
        public BillingPlanResponse(string Id)
        {
            PlanID = Id;
            PlanName = null;
            PlanDesc = null;
            BillingPlanType = null;
            CurrentState = null;
            CreateTime = null;
            UpdateTime = null;
            PaymentDefinitions = null;
            PaymentTerms = null;
            MerchPreference = null;
            CurrencyCode = null;
            Links = null;
        }

        public static string[] PlanTypeStrings = { "FIXED", "INFINITE" };
        public static string[] PlanStateStrings = { "CREATED", "ACTIVE", "INACTIVE" };

        [DataMember(Name = "id")]
        public string PlanID
        {
            get { return _planId; }
            set { _planId = value; }
        }

        [DataMember(Name = "name")]
        public string PlanName
        {
            get { return _planName; }
            set { _planName = value; }
        }

        [DataMember(Name = "description")]
        public string PlanDesc
        {
            get { return _planDesc; }
            set { _planDesc = value; }
        }

        [DataMember(Name = "type")]
        public string BillingPlanType
        {
            get { return _type; }
            set { _type = value; }
        }

        [DataMember(Name = "state")]
        public string CurrentState
        {
            get { return _state; }
            set { _state = value; }
        }

        [DataMember(Name = "create_time")]
        public string CreateTime
        {
            get { return _createTime; }
            set { _createTime = value; }
        }

        [DataMember(Name = "update_time")]
        public string UpdateTime
        {
            get { return _updateTime; }
            set { _updateTime = value; }
        }

        [DataMember(Name = "payment_definitions")]
        public List<PaymentDefinition> PaymentDefinitions
        {
            get { return _paymentDefinitions; }
            set { _paymentDefinitions = value; }
        }

        [DataMember(Name = "terms")]
        public List<Terms> PaymentTerms
        {
            get { return _paymentTerms; }
            set { _paymentTerms = value; }
        }

        [DataMember(Name = "merchant_preferences")]
        public MerchantPreferences MerchPreference
        {
            get { return _merchantPref; }
            set { _merchantPref = value; }
        }

        [DataMember(Name = "currency_code")]
        public Currency CurrencyCode
        {
            get { return _currencyCode; }
            set { _currencyCode = value; }
        }

        [DataMember(Name = "links")]
        public List<LinkDescription> Links
        {
            get { return _links; }
            set { _links = value; }
        }
    }

    [DataContract(Name = "link")]
    public class LinkDescription
    {
        private string _href;
        private string _rel;
        private string _method;

        [DataMember(Name = "href")]
        public string Href
        {
            get { return _href; }
            set { _href = value; }
        }

        [DataMember(Name = "rel")]
        public string Rel
        {
            get { return _rel; }
            set { _rel = value; }
        }

        [DataMember(Name = "method")]
        public string RequestMethod
        {
            get { return _method; }
            set { _method = value; }
        }
    }

    [DataContract(Name = "terms")]
    public class Terms
    {
        private string _id;
        private TermType _type;
        private Currency _maxBillingAmount;
        private string _occurrences;
        private Currency _amountRange;
        private string _buyerEditable;

        [DataMember(Name = "id")]
        public string Id
        {
            get { return _id; }
            set { _id = value; }
        }

        [DataMember(Name = "type")]
        public TermType TypeOfTerm
        {
            get { return _type; }
            set { _type = value; }
        }

        [DataMember(Name = "max_billing")]
        public Currency MaxBillingAmount
        {
            get { return _maxBillingAmount; }
            set { _maxBillingAmount = value; }
        }

        [DataMember(Name = "occurrences")]
        public string Occurrences
        {
            get { return _occurrences; }
            set { _occurrences = value; }
        }

        [DataMember(Name = "amount_range")]
        public Currency AmountRange
        {
            get { return _amountRange; }
            set { _amountRange = value; }
        }

        [DataMember(Name = "buyer_editable")]
        public string BuyerEditable
        {
            get { return _buyerEditable; }
            set { _buyerEditable = value; }
        }
    }

    [DataContract(Name = "max_amount")]
    public class Currency
    {
        private string _currency;
        private string _value;

        [DataMember(Name = "currency")]
        public string CurrencyCode
        {
            get { return _currency; }
            set { _currency = value; }
        }

        [DataMember(Name = "value")]
        public string Value
        {
            get { return _value; }
            set { _value = value; }
        }
    }

    [DataContract(Name = "payment_plan")]
    public class BillingPlanRequest
    {
        private string _name;
        private string _description;
        private string _type = "FIXED";
        private List<PaymentDefinition> _paymentDef;
        private MerchantPreferences _merchantPref = new MerchantPreferences();

        [DataMember(Name = "name")]
        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get { return _description; }
            set { _description = value; }
        }

        [DataMember(Name = "type")]
        public string Type
        {
            get { return _type; }
            set { _type = value; }
        }

        [DataMember(Name = "payment_definitions")]
        public List<PaymentDefinition> PaymentDef
        {
            get { return _paymentDef; }
            set { _paymentDef = value; }
        }

        [DataMember(Name = "merchant_preferences")]
        public MerchantPreferences MerchantPref
        {
            get { return _merchantPref; }
            set { _merchantPref = value; }
        }
    }

    [DataContract(Name = "payment_def")]
    public class PaymentDefinition
    {
        private string _name;
        private string _type;
        private string _frequency;
        private string _frequencyInterval;
        private Dictionary<string, string> _amount = new Dictionary<string, string>();
        private string _cycles;
        private List<ChargeModel> _chargeModels = new List<ChargeModel>();

        [DataMember(Name = "name")]
        public string Name
        {
            get { return _name; }
            set { _name = value; }
        }

        [DataMember(Name = "type")]
        public string PaymentType
        {
            get { return _type; }
            set { _type = value; }
        }

        [DataMember(Name = "frequency")]
        public string Frequency
        {
            get { return _frequency; }
            set { _frequency = value; }
        }

        [DataMember(Name = "frequency_interval")]
        public string FrequencyInterval
        {
            get { return _frequencyInterval; }
            set { _frequencyInterval = value; }
        }

        [DataMember(Name = "amount")]
        public Dictionary<string, string> Amount
        {
            get { return _amount; }
            set { _amount = value; }
        }

        [DataMember(Name = "cycles")]
        public string Cycles
        {
            get { return _cycles; }
            set { _cycles = value; }
        }

        [DataMember(Name = "charge_models")]
        public List<ChargeModel> ChargeModels
        {
            get { return _chargeModels; }
            set { _chargeModels = value; }
        }
    }

    [DataContract(Name = "charge_models")]
    public class ChargeModel
    {
        private string _chargeType;
        private Dictionary<string, string> _chargeAmount = new Dictionary<string, string>();

        [DataMember(Name = "type")]
        public string ChargeType
        {
            get { return _chargeType; }
            set { _chargeType = value; }
        }

        [DataMember(Name = "amount")]
        public Dictionary<string, string> ChargeAmount
        {
            get { return _chargeAmount; }
            set { _chargeAmount = value; }
        }
    }

    [DataContract(Name = "merchant_preferences")]
    public class MerchantPreferences
    {
        private Dictionary<string, string> _setupFee = new Dictionary<string, string>();
        private string _returnUrl;
        private string _cancelUrl;
        private string _autoBillAmount;
        private string _initialFailAmountAction;
        private string _maxFailAttempts;
        private string _notifyUrl;

        [DataMember(Name = "setup_fee")]
        public Dictionary<string, string> SetupFee
        {
            get { return _setupFee; }
            set { _setupFee = value; }
        }

        [DataMember(Name = "return_url")]
        public string ReturnUrl
        {
            get { return _returnUrl; }
            set { _returnUrl = value; }
        }

        [DataMember(Name = "cancel_url")]
        public string CancelUrl
        {
            get { return _cancelUrl; }
            set { _cancelUrl = value; }
        }

        [DataMember(Name = "auto_bill_amount")]
        public string AutoBillAmount
        {
            get { return _autoBillAmount; }
            set { _autoBillAmount = value; }
        }

        [DataMember(Name = "initial_fail_amount_action")]
        public string InitialFailAmountAction
        {
            get { return _initialFailAmountAction; }
            set { _initialFailAmountAction = value; }
        }

        [DataMember(Name = "max_fail_attempts")]
        public string MaxFailAttempts
        {
            get { return _maxFailAttempts; }
            set { _maxFailAttempts = value; }
        }

        [DataMember(Name = "notify_url")]
        public string NotifyUrl
        {
            get { return _notifyUrl; }
            set { _notifyUrl = value; }
        }
    }

    [DataContract(Name = "oauthobject")]
    public class PayPalOauthObject
    {
        private string _nonce;
        private string _accessToken;
        private string _tokenType;
        private string _appId;
        private int _expiresIn;

        [DataMember(Name = "nonce")]
        public string Nonce
        {
            get { return _nonce; }
            set { _nonce = value; }
        }

        [DataMember(Name = "access_token")]
        public string AccessToken
        {
            get { return _accessToken; }
            set { _accessToken = value; }
        }

        [DataMember(Name = "token_type")]
        public string TokenType
        {
            get { return _tokenType; }
            set { _tokenType = value; }
        }

        [DataMember(Name = "app_id")]
        public string AppId
        {
            get { return _appId; }
            set { _appId = value; }
        }

        [DataMember(Name = "expires_in")]
        public int ExpiresIn
        {
            get { return _expiresIn; }
            set { _expiresIn = value; }
        }
    }
}
