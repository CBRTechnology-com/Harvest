table 50007 "CBR StripeProduct"
{
    fields
    {
        field(1; Id; Text[50]) { DataClassification = CustomerContent; }
        field(2; Name; Text[50]) { DataClassification = CustomerContent; }
        field(3; Level; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = Standard,Premium;
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
        Name := JSONMethods.GetJsonValue('name').AsText();
        Evaluate(Level, JSONMethods.SelectJsonValue('$.metadata.level').AsText());
    end;

    procedure GetProducts()
    var
        StripeWebService: Codeunit "CBR StripeWebService";
    begin
        StripeWebService.GetProducts(Rec);
    end;
}