page 50003 "CBR Harvest Input Date"
{
    PageType = Card;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(FromDate; FromDate)
                {
                    ApplicationArea = All;
                    Caption = 'From Date';
                }
                field(ToDate; ToDate)
                {
                    ApplicationArea = All;
                    Caption = 'To Date';
                }
            }
        }
    }

    var
        FromDate: Date;
        ToDate: Date;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if (FromDate <> 0D) and (ToDate <> 0D) then
            SendStartEndDates(FromDate, ToDate);
    end;

    procedure SendStartEndDates(var LStrtDate: Date; var LEndDate: date)
    begin
        LStrtDate := FromDate;
        LEndDate := ToDate;
    end;
}