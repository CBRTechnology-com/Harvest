codeunit 50001 "CBR NotificationMgt"
{
    var
        TokTrialNotificationId: Label '0a275fd3-1e06-4980-8925-8b7154197ea7', locked = true;
        TokSubscriptionNotificationId: Label '8747ad38-dcd3-4f2f-979b-d4e746951ba0', locked = true;
        TrialExpiresMsg: Label 'Thank you for trying out the Merge Utility app. Your trial period expires in %1 days. Do you want to get a subscription?';
        SubscriptionExpiresMsg: Label 'Your subscription expires in %1 days. The subscription will automatically renew.';
        SubscriptionPastDueMsg: Label 'The payment of your subscription is %1 days overdue. Please contact us to solve this issue.';
        SubscriptionCanceledMsg: Label 'Your subscription has been canceled. Please buy a new subscription or contact us to solve this issue.';
        RequiredLevelMsg: Label 'You need a subscription for this feature. Do you want to upgrade?';
        BuySubscriptionActionText: Label 'Buy subscription...';
        ContactUsActionText: Label 'Contact us';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CBR StripCheckSubscriptStatus", 'OnTrialExpires', '', false, false)]
    local procedure CreateAndSendTrialExpiresMsg(TrialDaysLeft: Integer)
    var
        TrialNotification: Notification;
    begin
        with TrialNotification do begin
            Id := TokTrialNotificationId;
            Message := StrSubstNo(TrialExpiresMsg, TrialDaysLeft);
            Scope := NotificationScope::LocalScope;
            AddAction(BuySubscriptionActionText, Codeunit::"CBR NotificationMgt", 'BuySubscription');
            Send();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CBR StripCheckSubscriptStatus", 'OnSubscriptionPeriodEnds', '', false, false)]
    local procedure CreateAndSendCurrentPeriodEndMsg(CurrentPeriodDaysLeft: Integer)
    var
        SubscriptionNotification: Notification;
    begin
        with SubscriptionNotification do begin
            Id := TokSubscriptionNotificationId;
            Message := StrSubstNo(SubscriptionExpiresMsg, CurrentPeriodDaysLeft);
            Scope := NotificationScope::LocalScope;
            Send();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CBR StripCheckSubscriptStatus", 'OnSubscriptionPastDue', '', false, false)]
    local procedure CreateAndSendPastDueMsg(PastDueDays: Integer)
    var
        SubscriptionNotification: Notification;
    begin
        with SubscriptionNotification do begin
            Id := TokSubscriptionNotificationId;
            Message := StrSubstNo(SubscriptionPastDueMsg, PastDueDays);
            Scope := NotificationScope::LocalScope;
            AddAction(ContactUsActionText, Codeunit::"CBR NotificationMgt", 'ContactUs');
            Send();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CBR StripCheckSubscriptStatus", 'OnSubscriptionCanceled', '', false, false)]
    local procedure CreateAndSendCanceledMsg()
    var
        SubscriptionNotification: Notification;
    begin
        with SubscriptionNotification do begin
            Id := TokSubscriptionNotificationId;
            Message := SubscriptionCanceledMsg;
            Scope := NotificationScope::LocalScope;
            AddAction(BuySubscriptionActionText, Codeunit::"CBR NotificationMgt", 'BuySubscription');
            AddAction(ContactUsActionText, Codeunit::"CBR NotificationMgt", 'ContactUs');
            Send();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CBR StripCheckSubscrLevel", 'OnSubscriptionLevelFailed', '', false, false)]
    local procedure CreateAndSendSubscriptionLevelMsg()
    var
        SubscriptionNotification: Notification;
    begin
        with SubscriptionNotification do begin
            Id := TokSubscriptionNotificationId;
            Message := RequiredLevelMsg;
            Scope := NotificationScope::LocalScope;
            AddAction(BuySubscriptionActionText, Codeunit::"CBR NotificationMgt", 'BuySubscription');
            Send();
        end;
    end;

    procedure BuySubscription(SubscriptionNotification: Notification)
    begin
        Page.RunModal(Page::"CBR CreateSubscriptionWizard");
    end;

    procedure ContactUs(SubscriptionNotification: Notification)
    begin
        //TODO: contact us
    end;
}