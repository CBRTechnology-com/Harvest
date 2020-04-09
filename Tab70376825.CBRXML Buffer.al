table 50000 "CBR XML Buffer"
{
    // version CAN-HI1.00
    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; BigInteger)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; Text; Text[250])
        {
            Caption = 'Text';
            DataClassification = CustomerContent;
        }
        field(4; XPath; Text[230])
        {
            Caption = 'XPath';
            DataClassification = CustomerContent;
        }
        field(5; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(6; Value; Text[250])
        {
            Caption = 'Value';
            Description = 'CAN_DS field length increased 235--250';
            DataClassification = CustomerContent;
        }
        field(7; Level; Integer)
        {
            Caption = 'Level';
            DataClassification = CustomerContent;
        }
        field(8; "Session ID"; Integer)
        {
            DataClassification = CustomerContent;
        }
        field(9; LabelDigest; BLOB)
        {
            DataClassification = CustomerContent;
            Description = 'CAN_SH';
        }
        field(10; "Manufacturer Part No."; Text[50])
        {
            Description = 'For Ingram API New Field Added';
            DataClassification = CustomerContent;
        }
        field(11; SKU; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(12; Checked; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(13; "Extended Text"; Text[100])
        {
            DataClassification = CustomerContent;
            Description = 'CAN_DS';
        }
        field(14; "Extended Value"; Text[100])
        {
            DataClassification = CustomerContent;
            Description = 'CAN_DS';
        }
        field(15; "Item Line No."; Integer)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Line No.")
        {
        }
        key(Key2; "Entry No.", XPath)
        {
        }
    }

    fieldgroups
    {
    }
}

