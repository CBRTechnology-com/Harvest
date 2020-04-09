codeunit 50012 "CBR StripeInstall"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        InitData();
    end;

    local procedure InitData()
    var
        StripeSetup: Record "CBR StripeSetup";
    begin
        StripeSetup.RefreshData();
    end;
}