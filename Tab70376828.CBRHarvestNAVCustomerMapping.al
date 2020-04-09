table 50003 "CBR Harvest NAV Cust Mapping"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Client ID"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; "NAV Customer No."; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
        }
        field(3; "Client Name"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(4; "NAV Customer Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup (Customer.Name where ("No." = field ("NAV Customer No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Client ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}