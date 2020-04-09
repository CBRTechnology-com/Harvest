codeunit 50008 "CBR StripCreatSubscriptionMeth"
{
    procedure CreateSubcription(StripeCust: Record "CBR StripeCustomer"; StripePlan: Record "CBR StripePlan")
    begin
        DoCreateSubscription(StripeCust, StripePlan);
    end;

    local procedure DoCreateSubscription(StripeCust: Record "CBR StripeCustomer"; StripePlan: Record "CBR StripePlan")
    var
        StripeSubscription: Record "CBR StripeSubscription";
        StripeWebService: Codeunit "CBR StripeWebService";
    begin
        CheckCustomerDetails(StripeCust);
        StripeCust.UpdateCustomer();

        if StripeSubscription.FindFirst() then
            StripeWebService.UpdateSubscription(StripePlan, StripeSubscription)
        else
            StripeWebService.CreateSubscription(StripeCust, StripePlan, StripeSubscription);
    end;

    local procedure CheckCustomerDetails(StripeCust: Record "CBR StripeCustomer");
    begin
        with StripeCust do begin
            TestField(Name);
            TestField(Email);
        end;
    end;

}