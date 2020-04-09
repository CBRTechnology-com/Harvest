table 50006 "CBR StripeCustomer"
{

    fields
    {
        field(1; Id; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Account Balance"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(4; "VAT Id"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(5; Currency; Code[3])
        {
            DataClassification = CustomerContent;
        }
        field(6; Delinquent; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(7; Email; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(8; Name; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(9; Address; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(10; "Address 2"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Postal Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(12; City; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(13; State; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(14; Country; Code[2])
        {
            DataClassification = CustomerContent;
        }
        field(15; Phone; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(104; "Token Id"; Text[30])
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

    procedure CreateTrialCustomer()
    var
        CreateTrialCustomerMeth: Codeunit "CBR StripeCreateTrialCustMeth";
    begin
        CreateTrialCustomerMeth.CreateTrialCustomer(Rec);
    end;

    procedure UpdateCustomer()
    var
        StripeWebService: Codeunit "CBR StripeWebService";
    begin
        StripeWebService.UpdateCustomer(Rec);
    end;

    procedure CreateSubscription(StripePlan: Record "CBR StripePlan")
    var
        StripeCreateSubscriptionMeth: Codeunit "CBR StripCreatSubscriptionMeth";
    begin
        StripeCreateSubscriptionMeth.CreateSubcription(Rec, StripePlan);
    end;

    procedure GetAsFormData() Data: Text
    begin
        Data := 'email=' + Email +
                //'&business_vat_id=' + "VAT Id" +
                '&shipping[name]=' + Name +
                '&shipping[phone]=' + Phone +
                '&shipping[address][line1]=' + Address +
                '&shipping[address][line2]=' + "Address 2" +
                '&shipping[address][postal_code]=' + "Postal Code" +
                '&shipping[address][city]=' + City +
                '&shipping[address][state]=' + State +
                '&shipping[address][country]=' + Country;
        if "Token Id" <> '' then
            data := Data +
                '&source=' + "Token Id";
    end;

    procedure PopulateFromJson(Data: JsonObject)
    var
        JSONMethods: Codeunit "CBR JSONMethods";
    begin
        JSONMethods.SetJsonObject(Data);
        id := JSONMethods.GetJsonValue('id').AsText();
        "Account Balance" := JSONMethods.GetJsonValue('account_balance').AsInteger();
        Delinquent := JSONMethods.GetJsonValue('delinquent').AsBoolean();
    end;

}