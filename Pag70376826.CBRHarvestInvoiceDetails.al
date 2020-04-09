page 50001 "CBR Harvest Invoice Details"
{
    // version CAN-HI1.00

    InsertAllowed = false;
    PageType = List;
    UsageCategory = Administration;
    SourceTable = "CBR Harvest Invoice Details";
    PromotedActionCategories = 'New,Process,Report,Harvest';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Invoice No"; "Invoice No")
                {
                    Caption = 'Harvest Invoice ID';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Harvest Client ID"; "Harvest Client ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("NAV Customer No."; "NAV Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Client Name"; "Client Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Line Item"; "Line Item")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Line Item Description"; "Line Item Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Project ID"; "Project ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Project Name"; "Project Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Resource No."; "Resource No.")
                {
                    ApplicationArea = All;

                }
                field("Resouce Name"; "Resouce Name")
                {
                    ApplicationArea = All;

                }
                field("Period Start Date"; "Period Start Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Period End Date"; "Period End Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Issue Date"; "Issue Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Payment Terms"; "Payment Terms")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Invoice Created Date"; "Invoice Created Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {

            action(Invoices)
            {
                ApplicationArea = Advanced, Basic;
                Caption = 'Import Harvest Invoices';
                Image = Process;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction();
                var
                    PageInputDates: Page "CBR Harvest Input Date";
                    PageHarvestInputDate: Page "CBR Harvest Input Date";
                    StartDate: Date;
                    EndDate: Date;
                    Windows: Dialog;
                    Handled: Boolean;
                begin
                    CBR_OnBeforeAllowHarvest(Rec, Handled);
                    if not Handled then begin
                        //CAN_PS START 08042019
                        PageInputDates.RunModal();
                        PageInputDates.SendStartEndDates(StartDate, EndDate);
                        //CAN_PS STOP 08042019
                        Reset();

                        DELETEALL;
                        //HarvestIntegration.GetResponsefromHarvest; //CAN_PS 08042019 COMMENTED
                        Windows.OPEN('### Importing entries from Harvest ...');
                        HarvestIntegration.GetResponsefromHarvest(StartDate, EndDate);//CAN_PS 08042019 ADDED
                        Windows.Close;
                    end;
                end;
            }
            action(CreateInvoice)
            {
                ApplicationArea = Advanced, Basic;
                Caption = 'Create Sales Invoice';
                Image = Process;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction();
                var
                    RecHarvestInvdetail: Record "CBR Harvest Invoice Details";
                    SelectionCount: Integer;
                    Text001: Label 'Do you want to create the Sales Invoice ?';
                    Windows: Dialog;
                    RecSH: Record "Sales Header";
                    ExInvNum: Code[20];
                    Handled: Boolean;
                begin
                    CBR_OnBeforeAllowHarvest(Rec, Handled);
                    if not Handled then begin
                        CurrPage.SetSelectionFilter(RecHarvestInvdetail);
                        // if RecHarvestInvdetail.FindSet then
                        //     repeat
                        //         RecHarvestInvdetail.TestField("NAV Customer No.");
                        //     until RecHarvestInvdetail.Next = 0;
                        //CAN_PS 18042019 START
                        // if RecSH.get(RecSH."Document Type"::Invoice, Rec."Invoice No") then
                        //     Error('This invoice already exists \Invoice No.-%1', "Invoice No");
                        // RecHarvestInvdetail.Reset();
                        // RecHarvestInvdetail.SetRange("Invoice No", Rec."Invoice No");
                        //CAN_PS 18042019 STOP
                        Clear(SelectionCount);
                        //RecHarvestInvdetail.SetCurrentKey("Invoice No");
                        if RecHarvestInvdetail.FindSet then begin
                            if not Confirm(Text001, true) then
                                exit
                            else
                                Windows.OPEN('###### Processing......');
                            repeat
                                if RecSH.get(RecSH."Document Type"::Invoice, Rec."Invoice No") then
                                    Error('This invoice already exists \Invoice No.-%1', "Invoice No");
                                if RecHarvestInvdetail."Invoice No" <> ExInvNum then
                                    CreateSalesOrder_CBR(RecHarvestInvdetail."Invoice No");
                                ExInvNum := RecHarvestInvdetail."Invoice No";
                            until RecHarvestInvdetail.Next = 0;
                            RecHarvestInvdetail.DeleteAll();
                            Windows.CLOSE;
                            PAGE.RUN(9301);
                        end
                        else
                            Error('Please select the Invoice');
                    end;
                end;
            }

            action("Harvest NAV Customer Mapping")
            {
                ApplicationArea = All;
                //RunObject = page "Harvest NAV Customer Mapping";
                Promoted = true;
                PromotedCategory = Category4;
                Image = Setup;
                trigger OnAction()
                var
                    HarvestCustMapping: page "CBR Harvest NAV Cust Mapping";
                    Handled: Boolean;
                begin
                    CBR_OnBeforeAllowHarvest(Rec, Handled);
                    if not Handled then
                        HarvestCustMapping.Run();
                end;
            }
        }

    }

    var
        HarvestIntegration: Codeunit "CBR Harvest Integration";
        HarvestInvoiceDetails: Record "CBR Harvest Invoice Details";
        I: Integer;
        J: Integer;
        TempCustNo: Code[20];
        HarvestInvoiceDetails2: Record "CBR Harvest Invoice Details";


    local procedure CreateSalesOrder_CBR(var HarInvNo: Code[20])
    var
        RecHarInvDetails: Record "CBR Harvest Invoice Details";
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        LineNo: Integer;
        ExClientID: Code[20];
        ExCustNo: Code[20];
        RecHarvestNAVCustMapping: Record "CBR Harvest NAV Cust Mapping";
        ExHarInvNo: Code[20];
    begin
        RecHarInvDetails.Reset();
        RecHarInvDetails.SetCurrentKey("Invoice No");
        RecHarInvDetails.SetRange("Invoice No", HarInvNo);
        if RecHarInvDetails.FindSet then
            repeat
                //if (RecHarInvDetails."NAV Customer No." <> ExCustNo) or (RecHarInvDetails."Harvest Client ID" <> ExClientID) then begin
                if RecHarInvDetails."Invoice No" <> ExHarInvNo then begin
                    Clear(LineNo);
                    SH.INIT;
                    SH."Document Type" := SH."Document Type"::Invoice;
                    SH."No." := RecHarInvDetails."Invoice No";
                    SH.INSERT(true);
                    SH.VALIDATE("Sell-to Customer No.", RecHarInvDetails."NAV Customer No.");
                    SH.VALIDATE("Posting Date", RecHarInvDetails."Issue Date");
                    SH."CAN From Harvest" := true;
                    SH.MODIFY;
                    SL.INIT;
                    SL.VALIDATE("Document Type", SL."Document Type"::Invoice);
                    SL.VALIDATE("Document No.", SH."No.");
                    LineNo += 10000;
                    SL."Line No." := LineNo;
                    SL.INSERT(true);
                    SL.VALIDATE("Sell-to Customer No.", SH."Sell-to Customer No.");
                    SL.VALIDATE(Type, SL.Type::Resource);
                    SL.VALIDATE("No.", RecHarInvDetails."Resource No.");
                    SL.Description := COPYSTR(RecHarInvDetails."Line Item Description", 1, 50);
                    SL."Description 2" := COPYSTR(RecHarInvDetails."Line Item Description", 51, 50);
                    SL.VALIDATE(Quantity, RecHarInvDetails.Quantity);
                    SL.VALIDATE("Unit Price", RecHarInvDetails."Unit Price");
                    SL.MODIFY;
                end else begin
                    SL.INIT;
                    SL.VALIDATE("Document Type", SL."Document Type"::Invoice);
                    SL.VALIDATE("Document No.", SH."No.");
                    LineNo += 10000;
                    SL."Line No." := LineNo;
                    SL.INSERT(true);
                    SL.VALIDATE("Sell-to Customer No.", SH."Sell-to Customer No.");
                    SL.VALIDATE(Type, SL.Type::Resource);
                    SL.VALIDATE("No.", RecHarInvDetails."Resource No.");
                    SL.Description := COPYSTR(RecHarInvDetails."Line Item Description", 1, 50);
                    SL."Description 2" := COPYSTR(RecHarInvDetails."Line Item Description", 51, 50);
                    SL.VALIDATE(Quantity, RecHarInvDetails.Quantity);
                    SL.VALIDATE("Unit Price", RecHarInvDetails."Unit Price");
                    SL.MODIFY;
                end;
                ExClientID := RecHarInvDetails."Harvest Client ID";
                ExCustNo := RecHarInvDetails."NAV Customer No.";
                ExHarInvNo := RecHarInvDetails."Invoice No";
                //CAN_PS 04052019 START
                if not RecHarvestNAVCustMapping.Get(RecHarInvDetails."Harvest Client ID") then begin
                    RecHarvestNAVCustMapping.Init();
                    RecHarvestNAVCustMapping."Client ID" := RecHarInvDetails."Harvest Client ID";
                    RecHarvestNAVCustMapping."Client Name" := RecHarInvDetails."Client Name";
                    RecHarvestNAVCustMapping."NAV Customer No." := RecHarInvDetails."NAV Customer No.";
                    RecHarvestNAVCustMapping.Insert();
                end;
                //CAN_PS 04052019 STOP
                RecHarInvDetails.Delete();
            until RecHarInvDetails.Next = 0;
    end;

    local procedure UpdateResource()
    var
        ResourceRec: Record Resource;
    begin
        if ResourceRec.get("Resource No.") then begin
            "Resouce Name" := ResourceRec.Name;
            Modify();
        end;
    end;


    [IntegrationEvent(false, false)]
    procedure CBR_OnBeforeAllowHarvest(var Rec: Record "CBR Harvest Invoice Details"; var Handled: Boolean)
    begin
    end;
}

