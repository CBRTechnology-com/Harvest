codeunit 50007 "CBR StripeCreatTrialSubscrMeth"
{
    procedure CreateTrialSubscription(var Rec: Record "CBR StripeSubscription")
    begin
        DoCreateTrialSubscription(Rec);
    end;

    local procedure DoCreateTrialSubscription(var StripeSubscription: Record "CBR StripeSubscription")
    var
        StripeCustomer: Record "CBR StripeCustomer";
        StripeProduct: Record "CBR StripeProduct";
        StripePlan: Record "CBR StripePlan";
        StripeWebService: Codeunit "CBR StripeWebService";
    begin
        StripeCustomer.CreateTrialCustomer();

        // 1. Get product with level standard
        // 2. Get pricing plan for product (there will be only one, which include a 30-day trial period)
        // 3. Subscribe to the plan

        StripeProduct.SetCurrentKey(Level);
        if not StripeProduct.FindFirst() then
            exit;

        StripePlan.SetRange("Product Id", StripeProduct.Id);
        StripePlan.SetFilter("Trial Period Days", '<>%1', 0);
        StripePlan.FindFirst();

        StripeWebService.CreateSubscription(StripeCustomer, StripePlan, StripeSubscription);
    end;
}