page 50007 "CBR StripePlanSubpart"
{
    PageType = ListPart;
    SourceTable = "CBR StripePlan";
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = '';

    layout
    {
        area(Content)
        {
            repeater(StripePlans)
            {
                field(Select; Select)
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        if Select then begin
                            SetRange(Select, true);
                            SetFilter(Id, '<>%1', Id);
                            if FindFirst() then begin
                                Select := false;
                                Modify();
                            end;
                            SetRange(Id);
                            FindFirst();
                            SetRange(Select);
                        end;
                    end;
                }
                field("Product Name"; "Product Name")
                {
                    ApplicationArea = All;
                    Width = 15;
                }
                field(Currency; Currency)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Amount / 100)
                {
                    ApplicationArea = All;
                    DecimalPlaces = 2 : 2;
                    Editable = false;
                }
                field(Interval; Interval)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    var
        [InDataSet]
        Selected: Boolean;

    trigger OnOpenPage()
    begin
        GetPlans();
    end;

    procedure HasSelectedPlan() ReturnValue: Boolean
    begin
        SetRange(Select, true);
        ReturnValue := not IsEmpty();
        SetRange(Select);
    end;

    procedure GetSelectedPlan(var StripePlan: Record "CBR StripePlan")
    begin
        SetRange(Select, true);
        FindFirst();
        StripePlan := Rec;
    end;
}
