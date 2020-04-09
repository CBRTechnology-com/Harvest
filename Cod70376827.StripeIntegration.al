codeunit 50002 "CBR StripeIntegration"
{
    [EventSubscriber(ObjectType::Page, Page::"CBR Harvest Invoice Details", 'CBR_OnBeforeAllowHarvest', '', false, false)]
    procedure CheckAccessLevel_OnBeforeMergeGLAccount(var Rec: Record "CBR Harvest Invoice Details"; var Handled: Boolean)
    var
        StripeProduct: Record "CBR StripeProduct";
    begin
        OnCheckSubscriptionLevel(StripeProduct.Level::Standard, Handled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Conf./Personalization Mgt.", 'OnRoleCenterOpen', '', true, true)]
    local procedure CheckSubscriptionStatus_OnOpenRoleCenter()
    begin
        OnCheckSubscriptionStatus();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckSubscriptionLevel(RequiredLevel: Integer; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckSubscriptionStatus()
    begin
    end;
}