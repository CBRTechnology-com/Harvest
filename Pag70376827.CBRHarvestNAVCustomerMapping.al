page 50002 "CBR Harvest NAV Cust Mapping"
{
    PageType = List;
    SourceTable = "CBR Harvest NAV Cust Mapping";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Client ID"; "Client ID")
                {
                    ApplicationArea = All;
                }
                field("Client Name"; "Client Name")
                {
                    ApplicationArea = All;
                }
                field("NAV Customer No."; "NAV Customer No.")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        HarInvDetail: Record "CBR Harvest Invoice Details";
                        CustNo: Code[20];
                    begin
                        Clear(CustNo);
                        CustNo := "NAV Customer No.";
                        if ("Client ID" <> '') then begin
                            HarInvDetail.Reset();
                            HarInvDetail.SetRange("Harvest Client ID", "Client ID");
                            if FindSet() then
                                HarInvDetail.ModifyAll("NAV Customer No.", CustNo);
                            "NAV Customer No." := CustNo;
                            //CurrPage.Update(false);
                        end;
                    end;
                }
                field("NAV Customer Name"; "NAV Customer Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}