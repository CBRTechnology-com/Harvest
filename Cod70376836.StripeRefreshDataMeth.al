codeunit 50011 "CBR StripeRefreshDataMeth"
{
    procedure RefreshData(var StripeSetup: Record "CBR StripeSetup")
    begin
        DoRefreshData(StripeSetup);
    end;

    local procedure DoRefreshData(var StripeSetup: Record "CBR StripeSetup")
    var
        StripeProduct: Record "CBR StripeProduct";
        StripePlan: Record "CBR StripePlan";
        StripeSubscription: Record "CBR StripeSubscription";
    begin
        if not ShouldRefreshStripeData(StripeSetup) then
            exit;

        StripeProduct.GetProducts();
        StripePlan.GetPlans();
        if StripeSubscription.FindFirst() then
            StripeSubscription.RefreshSubscription()
        else
            StripeSubscription.CreateTrialSubscription();

        StripeSetup."Last Synchronized" := CurrentDateTime();
        StripeSetup.Modify();
    end;

    local procedure ShouldRefreshStripeData(var StripeSetup: Record "CBR StripeSetup") ReturnValue: Boolean
    begin
        StripeSetup.GetSetup();
        ReturnValue := true;
        if StripeSetup."Last Synchronized" <> 0DT then
            ReturnValue := (CurrentDateTime() - StripeSetup."Last Synchronized") > (24 * 60 * 60 * 1000);
    end;

}