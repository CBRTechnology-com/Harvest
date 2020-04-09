codeunit 50006 "CBR StripeCreateTrialCustMeth"
{
    procedure CreateTrialCustomer(var Rec: Record "CBR StripeCustomer")
    begin
        DoCreateTrialCustomer(Rec);
    end;

    local procedure DoCreateTrialCustomer(var StripeCustomer: Record "CBR StripeCustomer")
    var
        CompanyInfo: Record "Company Information";
        StripeWebService: Codeunit "CBR StripeWebService";
    begin
        GetCompanyInformation(CompanyInfo);
        InitStripeCustomer(StripeCustomer, CompanyInfo);
        StripeWebService.CreateCustomer(StripeCustomer);
        StripeCustomer.Insert();
    end;

    local procedure GetCompanyInformation(var CompanyInfo: Record "Company Information")
    begin
        if not CompanyInfo.Get() then
            CompanyInfo.Init();
    end;

    local procedure InitStripeCustomer(var StripeCustomer: Record "CBR StripeCustomer"; CompanyInfo: Record "Company Information")
    begin
        with StripeCustomer do begin
            Init();
            Name := CompanyInfo.Name;
            Email := CompanyInfo."E-Mail";
            Address := CompanyInfo.Address;
            "Postal Code" := CompanyInfo."Post Code";
            City := CompanyInfo.City;
            State := CompanyInfo.County;
            Country := CompanyInfo."Country/Region Code";
        end;
    end;
}