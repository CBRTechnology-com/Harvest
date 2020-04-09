table 50008 "CBR StripeSubscription"
{

    fields
    {
        field(1; Id; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Created"; BigInteger)
        {
            DataClassification = CustomerContent;
        }
        field(3; "Current Period Start"; BigInteger)
        {
            DataClassification = CustomerContent;
        }
        field(4; "Current Period End"; BigInteger)
        {
            DataClassification = CustomerContent;
        }
        field(5; "Subscription Item Id"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Ended At"; BigInteger)
        {
            DataClassification = CustomerContent;
        }
        field(7; "Plan Id"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; Quantity; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(9; Status; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Trialing,Active,past_due,Canceled,Unpaid;
            OptionCaption = 'Evaluation,Active,Past Due,Canceled,Unpaid';
        }
        field(10; "Trial Start"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(11; "Trial End"; Integer)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }

    procedure RefreshSubscription()
    var
        StripeWebService: Codeunit "CBR StripeWebService";
    begin
        StripeWebService.RefreshSubscription(Rec);
    end;

    procedure CreateTrialSubscription()
    var
        StripeCreateSubscriptionMeth: Codeunit "CBR StripeCreatTrialSubscrMeth";
    begin
        StripeCreateSubscriptionMeth.CreateTrialSubscription(Rec);
    end;

    procedure GetFormDataForCreateSubscription(StripePlan: Record "CBR StripePlan"; StripeCustomer: Record "CBR StripeCustomer") Data: Text
    begin
        Data := 'items[0][plan]=' + StripePlan.Id +
                '&customer=' + StripeCustomer.Id +
                '&trial_period_days=' + Format(StripePlan."Trial Period Days");
    end;

    procedure GetFormDataForUpdateSubscription(StripePlan: Record "CBR StripePlan") Data: Text
    begin
        if "Plan Id" <> '' then
            Data := 'items[0][id]=' + "Subscription Item Id" +
                    '&items[0][deleted]=true' +
                    '&items[1][plan]=' + StripePlan.Id
        else
            Data := 'items[0][plan]=' + StripePlan.Id;
    end;

    procedure PopulateFromJson(Data: JsonObject)
    var
        JSONMethods: Codeunit "CBR JSONMethods";
    begin
        JSONMethods.SetJsonObject(Data);
        Id := JSONMethods.GetJsonValue('id').AsText();
        Created := JSONMethods.GetJsonValue('created').AsBigInteger();
        "Current Period Start" := JSONMethods.GetJsonValue('current_period_start').AsBigInteger();
        if not JSONMethods.IsNullValue('current_period_end') then
            "Current Period End" := JSONMethods.GetJsonValue('current_period_end').AsBigInteger();
        if not JSONMethods.IsNullValue('ended_at') then
            "Ended At" := JSONMethods.GetJsonValue('ended_at').AsInteger();

        Evaluate(Status, JSONMethods.GetJsonValue('status').AsText());

        if not JSONMethods.IsNullValue('trial_start') then
            "Trial Start" := JSONMethods.GetJsonValue('trial_start').AsBigInteger();
        if not JSONMethods.IsNullValue('trial_end') then
            "Trial End" := JSONMethods.GetJsonValue('trial_end').AsBigInteger();

        Quantity := JSONMethods.GetJsonValue('quantity').AsInteger();
        "Subscription Item Id" := JSONMethods.SelectJsonValue('$.items.data[0].id').AsText();
        "Plan Id" := JSONMethods.SelectJsonValue('$.plan.id').AsText();
    end;

    procedure TrialDaysLeft() ReturnValue: Integer
    var
        TypeHelper: Codeunit "Type Helper";
        TrialEndDate: Date;
    begin
        TrialEndDate := DT2Date(TypeHelper.EvaluateUnixTimestamp("Trial End"));
        ReturnValue := TrialEndDate - Today();
    end;

    procedure CurrentPeriodDaysLeft() ReturnValue: Integer
    var
        TypeHelper: Codeunit "Type Helper";
        PeriodEndDate: Date;
    begin
        PeriodEndDate := DT2Date(TypeHelper.EvaluateUnixTimestamp("Current Period End"));
        ReturnValue := PeriodEndDate - Today();
    end;

    procedure PastDueDays() ReturnValue: Integer
    begin
        if CurrentPeriodDaysLeft() < 0 then
            ReturnValue := Abs(CurrentPeriodDaysLeft())
        else
            ReturnValue := 0;
    end;
}