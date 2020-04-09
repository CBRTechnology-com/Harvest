table 50001 "CBR Harvest Setup"
{
    // version CAN-HI1.00


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; "Set Content Type"; Text[100])
        {
            DataClassification = CustomerContent;
            InitValue = 'application/json';
        }
        field(3; "Set Return Type"; Text[100])
        {
            DataClassification = CustomerContent;
            InitValue = 'application/json';
        }
        field(4; "Harvest Token Name"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(5; "Harvest Account ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(6; "Harvest Access Code"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(7; "Harvest Invoice Web API"; Text[150])
        {
            DataClassification = CustomerContent;
            Editable = false;
            InitValue = 'https://api.harvestapp.com/v2/invoices?access_token=';
        }
        field(8; "Invoice Response File Path"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(9; "Default Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

