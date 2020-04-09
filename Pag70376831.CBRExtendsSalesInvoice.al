pageextension 50006 CBR_Extendsaleslist extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
        addbefore("No.")
        {
            field("CAN From Harvest"; "CAN From Harvest")
            {
                ApplicationArea = All;
                Caption = 'From Harvest';
            }
        }
    }


    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}