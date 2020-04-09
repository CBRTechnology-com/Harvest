table 50005 "CBR StripeSetup"
{
    fields
    {
        field(1; PK; Code[10]) { DataClassification = CustomerContent; }
        field(2; "Last Synchronized"; DateTime) { DataClassification = CustomerContent; }

    }

    procedure GetSetup()
    begin
        if not FindFirst() then begin
            Init();
            Insert();
        end;
    end;

    procedure RefreshData()
    var
        StripeRefreshDataMeth: Codeunit "CBR StripeRefreshDataMeth";
    begin
        StripeRefreshDataMeth.RefreshData(Rec);
    end;
}