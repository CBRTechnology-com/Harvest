pageextension 50005 CBR_ExtBusinessManagRolecenter extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("Chart of Accounts")
        {
            action(Harvest)
            {
                ApplicationArea = All;
                Caption = 'Harvest TimeSheet Entries';
                RunObject = page "CBR Harvest Invoice Details";
                RunPageMode = Edit;
            }
        }
    }

    var
        myInt: Integer;
}