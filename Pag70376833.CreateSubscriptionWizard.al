page 50008 "CBR CreateSubscriptionWizard"
{
    PageType = NavigatePage;
    SourceTable = "CBR StripeCustomer";
    Caption = 'CREATE SUBSCRIPTION';

    layout
    {
        area(Content)
        {
            group(BannerStandard)
            {
                Editable = false;
                Visible = TopBannerVisible and (CurrentStep < 4);
                field(MediaResourcesStandard; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }
            group(BannerDone)
            {
                Editable = false;
                Visible = TopBannerVisible and (CurrentStep = 4);
                field(MediaResourcesDone; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                }
            }
            group(Step1)
            {
                Visible = (CurrentStep = 1);
                group(Plan)
                {
                    Caption = 'Choose a plan';
                    InstructionalText = 'Choose a subscription plan from the list below';
                    part(Plans; "CBR StripePlanSubpart")
                    {
                        Caption = 'Plans';
                        ApplicationArea = All;
                    }

                }
            }
            group(Step2)
            {
                Visible = (CurrentStep = 2);
                group(Customer)
                {
                    Caption = 'Customer details';
                    InstructionalText = 'Provide your company details';
                    field(Name; Name)
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }
                    field(Address; Address)
                    {
                        ApplicationArea = All;
                    }
                    field(PostalCode; "Postal Code")
                    {
                        ApplicationArea = All;
                    }
                    field(City; City)
                    {
                        ApplicationArea = All;
                    }
                    field(State; State)
                    {
                        ApplicationArea = All;
                    }
                    field(Country; Country)
                    {
                        ApplicationArea = All;
                    }
                    field(Phone; Phone)
                    {
                        ApplicationArea = All;
                    }
                    field(Email; Email)
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                    }

                }
            }
            group(Step3)
            {
                Visible = (CurrentStep = 3);
                group(CreditCardInstruction)
                {

                    Caption = 'Credit card details';
                    InstructionalText = 'Please fill in your credit card details below. They will be safely stored with our payment provider Stripe. No credit card information will be stored in Microsoft Dynamics 365 Business Central;.';
                }
                group(CreditCardDetails)
                {
                    ShowCaption = false;
                    usercontrol(CreditCardControl; StripeCreditCardControl)
                    {
                        ApplicationArea = All;
                        trigger ControlAddInReady()
                        begin
                            CheckoutControlIsReady := true;
                            InializeCheckoutControl();
                        end;

                        trigger InputChanged(complete: Boolean)
                        begin
                            CreditCardInputComplete := complete;
                            SetControls();
                        end;

                        trigger StripeTokenCreated(newTokenId: Text)
                        begin
                            Rec."Token Id" := newTokenId;
                            CurrentStep += 1;
                            SetControls();
                        end;
                    }
                }
            }
            group(Step4)
            {
                Visible = (CurrentStep = 4);
                group(Overview)
                {
                    Caption = 'All done';
                    InstructionalText = 'Click on Finish to create your subscription. Thank you for choosing the Merge Utility app!';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionBack)
            {
                ApplicationArea = All;
                Caption = 'Back';
                Enabled = ActionBackAllowed;
                Image = PreviousRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    TakeStep(-1);
                end;
            }
            action(ActionNext)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Enabled = ActionNextAllowed;
                Image = NextRecord;
                InFooterBar = true;

                trigger OnAction()
                begin
                    TakeStep(1);
                end;
            }
            action(ActionFinish)
            {
                ApplicationArea = All;
                Caption = 'Finish';
                Enabled = ActionFinishAllowed;
                Image = Approve;
                InFooterBar = true;

                trigger OnAction()
                begin
                    Finish();
                end;
            }

        }
    }

    var
        CurrentStep: Integer;
        ActionBackAllowed: Boolean;
        ActionNextAllowed: Boolean;
        ActionFinishAllowed: Boolean;
        MediaRepositoryStandard: Record "Media Repository";
        MediaRepositoryDone: Record "Media Repository";
        MediaResourcesStandard: Record "Media Resources";
        MediaResourcesDone: Record "Media Resources";
        TopBannerVisible: Boolean;
        CheckoutControlIsReady: Boolean;
        CreditCardInputComplete: Boolean;
        NoPlanSelectedErr: Label 'Please select a plan';

    trigger OnInit()
    begin
        LoadTopBanners();
    end;

    trigger OnOpenPage()
    begin
        CurrentStep := 1;
        SetControls();
    end;

    local procedure SetControls()
    begin
        ActionBackAllowed := CurrentStep > 1;
        ActionNextAllowed := (CurrentStep < 3) or ((CurrentStep = 3) and CreditCardInputComplete);
        ActionFinishAllowed := CurrentStep = 4;
    end;

    local procedure TakeStep(Step: Integer)
    begin
        if (CurrentStep = 3) and (Step = 1) and (Rec."Token Id" = '') then
            Step := 0;
        CheckCustomerData();
        CurrentStep += Step;
        SetControls();
    end;

    local procedure Finish()
    var
        StripePlan: Record "CBR StripePlan";
    begin
        CurrPage.Plans.Page.GetSelectedPlan(StripePlan);
        Rec.CreateSubscription(StripePlan);
        CurrPage.Close();
    end;

    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(CurrentClientType())) and
           MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(CurrentClientType()))
        then
            if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and
               MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")
            then
                TopBannerVisible := MediaResourcesDone."Media Reference".HasValue();
    end;

    local procedure CheckCustomerData()
    begin
        case CurrentStep of
            1:
                if not CurrPage.Plans.Page.HasSelectedPlan() then
                    Error(NoPlanSelectedErr);
            2:
                begin
                    Rec.TestField(Name);
                    Rec.TestField(Email);
                end;
            3:
                CurrPage.CreditCardControl.CreateStripeToken();
        end;
    end;

    local procedure InializeCheckoutControl()
    begin
        if not CheckoutControlIsReady then
            exit;
        CurrPage.CreditCardControl.InitializeCheckOutForm();
    end;
}