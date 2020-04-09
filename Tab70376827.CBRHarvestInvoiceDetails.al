table 50002 "CBR Harvest Invoice Details"
{
    // version CAN-HI1.00


    fields
    {
        field(1; "Invoice Entry No"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(2; "Invoice ID."; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(3; "NAV Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(4; "Client Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Line Item"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Line Item Description"; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(7; Quantity; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(8; "Unit Price"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(9; Amount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(10; "Project ID"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(11; "Project Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(12; "Period Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Period End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(14; "Issue Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(15; "Due Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(16; "Payment Terms"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(17; "Invoice Created Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(18; "Currency Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(19; Distinct; Boolean)
        {
            DataClassification = CustomerContent;
        }
        //CAN_PS 04052019 START
        field(20; "Resouce Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(21; "Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
            trigger OnValidate();
            begin
                UpdateResource();
            end;

        }
        field(22; "Default Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
        }
        //CAN_PS 04052019 STOP
        //CAN_PS 14042019 START
        field(23; "Invoice No"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(24; "Harvest Client ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        //CAN_PS 14042019 START
    }

    keys
    {
        key(Key1; "Invoice Entry No")
        {
        }
    }

    fieldgroups
    {
    }
    local procedure UpdateResource()
    var
        ResourceRec: Record Resource;
    begin
        if ResourceRec.get("Resource No.") then begin
            "Resouce Name" := ResourceRec.Name;
            Modify();
        end;
    end;

}

