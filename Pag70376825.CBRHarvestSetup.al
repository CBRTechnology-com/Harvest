page 50000 "CBR Harvest Setup"
{
    // version CAN-HI1.00

    PageType = Card;
    SourceTable = "CBR Harvest Setup";
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Harvest Token Name"; "Harvest Token Name")
                {
                    ApplicationArea = All;
                }
                field("Harvest Account ID"; "Harvest Account ID")
                {
                    ApplicationArea = All;
                }
                field("Harvest Access Code"; "Harvest Access Code")
                {
                    ApplicationArea = All;
                }
                field("Invoice Response File Path"; "Invoice Response File Path")
                {
                    ApplicationArea = All;
                }
                field("Default Resource No."; "Default Resource No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Harvest NAV Customer Mapping")
            {
                ApplicationArea = All;
                RunObject = page "CBR Harvest NAV Cust Mapping";
                Promoted = true;
                PromotedCategory = Process;
                Image = Setup;
            }
            action(Resource)
            {
                ApplicationArea = All;
                Image = Resource;
                RunObject = page "Resource List";
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Update Subcription Status")
            {
                ApplicationArea = All;
                Image = "Invoicing-Payment";
                ToolTip = 'Get the latest subsciption status';

                trigger OnAction();
                var
                    StripeSubscription: Record "CBR StripeSubscription";
                    StripeWebService: Codeunit "CBR StripeWebService";
                    StripePlan: Record "CBR StripePlan";
                    Text003: Label 'Updated';
                begin
                    if StripePlan.FindFirst() then
                        if StripeSubscription.FindFirst() then
                            StripeWebService.UpdateSubscription(StripePlan, StripeSubscription);
                    Message(Text003);
                    message('%1,%2', StripeSubscription.Status, StripeSubscription.Id)
                end;
            }
            action(HarvestTest)
            {
                ApplicationArea = All;
                Caption = 'Harvest', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = UpdateShipment;
                trigger OnAction()
                var
                    HarvestCodeUnit: Codeunit HarvestIntegration;
                begin
                    HarvestCodeUnit.GetProducts();
                end;
            }
            action(stripe)
            {
                ApplicationArea = All;
                Caption = 'stripe', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = UpdateShipment;
                trigger OnAction()
                var
                    HarvestCodeUnit: Codeunit "CBR StripeWebService";
                    stripeproducts: Record "CBR StripeProduct";
                begin
                    HarvestCodeUnit.GetProducts(stripeproducts);
                end;
            }
        }
    }
}


