codeunit 50009 "CBR StripCheckSubscrLevel"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CBR StripeIntegration", 'OnCheckSubscriptionLevel', '', false, false)]
    local procedure CheckSubscriptionLevel(RequiredLevel: Integer; var Handled: Boolean)
    var
        StripeSubscription: Record "CBR StripeSubscription";
        StripePlan: Record "CBR StripePlan";
        StripeProduct: Record "CBR StripeProduct";
    begin
        if not StripeSubscription.FindFirst() then
            StripeSubscription.CreateTrialSubscription();

        if StripeSubscription.Status in
            [StripeSubscription.Status::Canceled,
             StripeSubscription.Status::Unpaid]
        then begin
            OnSubscriptionLevelFailed();
            Handled := true;
            exit;
        end;

        //NOTE: Level check only needed when levels are being used
        StripePlan.Get(StripeSubscription."Plan Id");
        StripeProduct.Get(StripePlan."Product Id");

        if StripeProduct.Level < RequiredLevel then begin
            OnSubscriptionLevelFailed();
            Handled := true;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSubscriptionLevelFailed()
    begin
    end;
}