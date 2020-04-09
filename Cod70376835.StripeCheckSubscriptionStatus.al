codeunit 50010 "CBR StripCheckSubscriptStatus"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CBR StripeIntegration", 'OnCheckSubscriptionStatus', '', false, false)]
    local procedure CheckSubscriptionStatus()
    var
        StripeSetup: Record "CBR StripeSetup";
        StripeSubscription: Record "CBR StripeSubscription";
    begin
        StripeSetup.RefreshData();
        StripeSubscription.FindFirst();

        case StripeSubscription.Status of
            StripeSubscription.Status::Trialing:
                OnTrialExpires(StripeSubscription.TrialDaysLeft);
            StripeSubscription.Status::Active:
                if StripeSubscription.CurrentPeriodDaysLeft <= 30 then
                    OnSubscriptionPeriodEnds(StripeSubscription.CurrentPeriodDaysLeft());
            StripeSubscription.Status::past_due:
                OnSubscriptionPastDue(StripeSubscription.PastDueDays);
            StripeSubscription.Status::Canceled:
                OnSubscriptionCanceled();
            StripeSubscription.Status::Unpaid:
                OnSubscriptionUnpaid();
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnTrialExpires(TrialDaysLeft: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSubscriptionPeriodEnds(CurrentPeriodDaysLeft: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSubscriptionPastDue(PastDueDays: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSubscriptionCanceled()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSubscriptionUnpaid()
    begin
    end;

}