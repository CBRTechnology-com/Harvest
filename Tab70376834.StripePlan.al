table 50009 "CBR StripePlan"
{

    fields
    {
        field(1; Id; Text[50]) { DataClassification = CustomerContent; }
        field(2; "Product Id"; Text[50]) { DataClassification = CustomerContent; }
        field(3; "Product Name"; Text[50])
        {

            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup ("CBR StripeProduct".Name where (Id = field ("Product Id")));

        }
        field(4; Amount; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(5; Currency; Code[3])
        {
            DataClassification = CustomerContent;
            Caption = 'Currency';
        }
        field(6; Interval; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Interval';
            OptionMembers = day,week,month,year;
            OptionCaption = 'day,week,month,year';
        }
        field(7; "Interval Count"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Interval count';
        }
        field(8; "Trial Period Days"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Trial Period (Days)';
        }
        field(9; Select; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Select';
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }


    procedure PopulateFromJson(Data: JsonObject)
    var
        JSONMethods: Codeunit "CBR JSONMethods";
    begin
        JSONMethods.SetJsonObject(Data);
        Id := JSONMethods.GetJsonValue('id').AsText();
        "Product Id" := JSONMethods.GetJsonValue('product').AsText();
        Amount := JSONMethods.GetJsonValue('amount').AsDecimal();
        Currency := JSONMethods.GetJsonValue('currency').AsCode();
        Evaluate(Interval, JSONMethods.GetJsonValue('interval').AsText());
        "Interval Count" := JSONMethods.GetJsonValue('interval_count').AsInteger();
        "Trial Period Days" := JSONMethods.GetJsonValue('trial_period_days').AsInteger();
    end;

    procedure GetPlans()
    var
        StripeWebService: Codeunit "CBR StripeWebService";
    begin
        StripeWebService.GetPlans(Rec);
    end;
}