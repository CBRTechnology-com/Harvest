codeunit 50000 "CBR Harvest Integration"
{
    // version CAN-HI1.00

    trigger OnRun();
    begin
    end;

    var
        CANHarvestSetup: Record "CBR Harvest Setup";
        NodeLevel: Integer;
        HttpWebRequest: DotNet DWebRequest;
        CookieContainer: DotNet DCookieContainer;
        TempESTXMLBuffer: Record "CBR XML Buffer";
        TempESTXMLBuffer2: Record "CBR XML Buffer";
        HarvestInvoiceDetails: Record "CBR Harvest Invoice Details";
        Day: Integer;
        Month: Integer;
        Year: Integer;
        TempText: Text;
        ProjName: array[1000] of Text;
        I: Integer;
        J: Integer;
        InvID: array[1000] of Text;
        K: Integer;
        TempSku: Text;
        EntryNo: array[1000] of Integer;
        Windows: Dialog;
        InvURL: Text;
        GStartDate: Date;
        GEndDate: Date;

    local procedure JsonToXMLCreateDefaultRoot(JsonInStream: InStream; VAR XMLOutStream: OutStream)
    var
        VarXmlDocument: DotNet DxmlDoc;
        NewContent: Text;
        FileContent: Text;
        varJsonConvert: DotNet DJsonConvert;
    begin
        CANHarvestSetup.GET; //CAN-HI-CAN_DS1.00
        WHILE JsonInStream.READ(NewContent) > 0 DO
            FileContent += NewContent;

        FileContent := '{"root":' + FileContent + '}';
        VarXmlDocument := varJsonConvert.DeserializeXmlNode(FileContent, 'root');
        //VarXmlDocument := varJsonConvert.DeserializeXNode(FileContent, 'root');
        VarXmlDocument.Save(XMLOutStream);
        VarXmlDocument.Save(CANHarvestSetup."Invoice Response File Path");
    end;

    local procedure GetResponsefromHarvestdaily();
    var
        SOAPWebServiceRequestMgt: Codeunit "SOAP Web Service Request Mgt.";
        ReqBodyOutStrema: OutStream;
        ReqBodyInStream: InStream;
        HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
        TempBlob: Record TempBlob;
        Instr: InStream;
        HttpStatusCode: DotNet DHttpStatusCode;
        ResponseHeader: DotNet DResponseHeader;
        JObjects: DotNet DJObjects;
        Response: DotNet DWebResponse;
        Json: Text;
        ostream: OutStream;
        temp: Text;
        CU1237: Codeunit "Get Json Structure";
        AccessToken: TextConst ENU = '1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg', ENN = '1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg';
        URLs: Text;
        WebRequestHelper: Codeunit "Web Request Helper";
        URL: TextConst ENU = 'https://api.harvestapp.com/v2/users/me?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286', ENN = 'https://api.harvestapp.com/v2/users/me?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
        URL1: TextConst ENU = 'https://canarysautomationpvtltd.harvestapp.com/daily?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286', ENN = 'https://canarysautomationpvtltd.harvestapp.com/daily?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
        URL2: TextConst ENU = 'https://api.harvestapp.com/v2/time_entries?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286', ENN = 'https://api.harvestapp.com/v2/time_entries?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
        Auth: TextConst ENU = 'https://api.harvestapp.com/v2/users/me?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
        Week: TextConst ENU = 'https://canarysautomationpvtltd.harvestapp.com/reports?from=2018-12-24&kind=week&till=2018-12-30';
        Week1: TextConst ENU = 'https://canarysautomationpvtltd.harvestapp.com/time/week?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
    begin
        //URL := 'https://canarysautomationpvtltd.harvestapp.com/daily';

        HttpWebRequestMgt.Initialize(URL1);
        HttpWebRequestMgt.DisableUI;
        // HttpWebRequestMgt.SetMethod('GET');
        HttpWebRequestMgt.SetContentType('application/json');
        HttpWebRequestMgt.SetReturnType('application/json');
        JObjects := JObjects.JObject();
        TempBlob.INIT;
        TempBlob.Blob.CREATEINSTREAM(Instr);

        if HttpWebRequestMgt.GetResponse(Instr, HttpStatusCode, ResponseHeader)
          then begin
            if HttpStatusCode.ToString = HttpStatusCode.OK.ToString
              then begin
                Json := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
                JObjects := JObjects.Parse(Json);
                JObjects.GetValue('results');
                temp := JObjects.ToString();
                //temp := JObjects.GetValue('state').ToString;
                MESSAGE(temp);
                //MESSAGE(Json);
            end else
                MESSAGE('Response from API');
        end else
            MESSAGE('no response from api');

        TempBlob.Blob.CREATEOUTSTREAM(ostream);
        //CU1237.JsonToXMLCreateDefaultRoot(Instr, ostream);
        JsonToXMLCreateDefaultRoot(Instr, ostream);
    end;

    procedure GetResponsefromHarvest(LStartDate: Date; LEndDate: date);
    var
        AccessToken: TextConst ENU = '1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg', ENN = '1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg';
        // URL: TextConst ENU = 'https://api.harvestapp.com/v2/users/me?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286', ENN = 'https://api.harvestapp.com/v2/users/me?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
        // URL1: TextConst ENU = 'https://canarysautomationpvtltd.harvestapp.com/daily?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286', ENN = 'https://canarysautomationpvtltd.harvestapp.com/daily?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
        // URL2: TextConst ENU = 'https://api.harvestapp.com/v2/time_entries?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286', ENN = 'https://api.harvestapp.com/v2/time_entries?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
        // Auth: TextConst ENU = 'https://api.harvestapp.com/v2/users/me?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
        // Week: TextConst ENU = 'https://canarysautomationpvtltd.harvestapp.com/reports?from=2018-12-24&kind=week&till=2018-12-30';
        // Week1: TextConst ENU = 'https://canarysautomationpvtltd.harvestapp.com/time/week?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
        JObjects: DotNet DJObjects;
        TempBlob: Record TempBlob;
        Instr: InStream;
        ostream: OutStream;
        temp: Text;
        Bool: Boolean;
        Json: Text;
        HttpStatusCode: DotNet DHttpStatusCode;
        ResponseHeader: DotNet DResponseHeader;
        Response: DotNet DWebResponse;
        CU1237: Codeunit "Get Json Structure";
        WebRequestHelper: Codeunit "Web Request Helper";
        ResponseHeaders: DotNet DResponseHeader;
        Invoices: TextConst ENU = 'https://api.harvestapp.com/v2/invoices?access_token=1735814.pt.GZaNAZf80PR04rIHUqz1gu1Tuc5jMyHHXSGrYvUYNoi10E4MC0zBnuFspFosR1h64VJeh4ppXfTXmztDFx2zAg&account_id=997286';
    begin
        GStartDate := LStartDate; //CAN_PS ADDED
        GEndDate := LEndDate;//CAN_PS ADDED

        CANHarvestSetup.GET;
        InvURL := CANHarvestSetup."Harvest Invoice Web API" + CANHarvestSetup."Harvest Access Code" + '&account_id=' + CANHarvestSetup."Harvest Account ID";
        //HttpWebRequest := HttpWebRequest.Create(URL2);
        //HttpWebRequest := HttpWebRequest.Create(Invoices);
        HttpWebRequest := HttpWebRequest.Create(InvURL);
        HttpWebRequest.Method := 'GET';
        HttpWebRequest.KeepAlive := true;
        HttpWebRequest.AllowAutoRedirect := true;
        HttpWebRequest.UseDefaultCredentials := true;
        HttpWebRequest.UserAgent(CANHarvestSetup."Harvest Token Name");
        HttpWebRequest.Credentials();
        HttpWebRequest.Timeout := 60000;
        //HttpWebRequest.Accept('application/json');
        //HttpWebRequest.ContentType('application/json');
        HttpWebRequest.Accept(CANHarvestSetup."Set Content Type");
        HttpWebRequest.ContentType(CANHarvestSetup."Set Return Type");
        CookieContainer := CookieContainer.CookieContainer;
        HttpWebRequest.CookieContainer := CookieContainer;
        HttpWebRequest.GetResponse;

        JObjects := JObjects.JObject();
        TempBlob.INIT;
        TempBlob.Blob.CREATEINSTREAM(Instr);

        if WebRequestHelper.GetWebResponse(HttpWebRequest, Response, Instr, HttpStatusCode,
            ResponseHeaders, false)
          then begin
            if HttpStatusCode.ToString = HttpStatusCode.OK.ToString
              then begin
                Json := TempBlob.ReadAsText('', TEXTENCODING::UTF8);
                JObjects := JObjects.Parse(Json);
                JObjects.GetValue('results');
                temp := JObjects.ToString();
                //temp := JObjects.GetValue('state').ToString;
                //MESSAGE(temp);
                //MESSAGE(Json);
            end else
                MESSAGE('Response from Harvest');
        end else
            MESSAGE('No response from Harvest');

        TempBlob.Blob.CREATEOUTSTREAM(ostream);
        JsonToXMLCreateDefaultRoot(Instr, ostream);
        RunHarvest;
    end;

    local procedure RunHarvest();
    var
        XMLDOMManagement: Codeunit "XML DOM Management";
        _xmlDoc: DotNet DxmlDoc;
        varxmlNode: DotNet DxmlNode;
        varxmlNodelist: DotNet DxmlNodelist;
        xmlNode2: DotNet DxmlNode;
        ESTXmlBuffer: Record "CBR XML Buffer";
    begin
        CANHarvestSetup.GET;
        ESTXmlBuffer.DELETEALL;
        _xmlDoc := _xmlDoc.XmlDocument;
        //_xmlDoc.Load('C:\Users\deveshs\Desktop\Harvest\Daily.xml');
        _xmlDoc.Load(CANHarvestSetup."Invoice Response File Path");
        varxmlNode := _xmlDoc.DocumentElement;
        ProcessXML(varxmlNode, ESTXmlBuffer, 0);
        UpdateLineItems;
        TraversChildInvoices2;
        MESSAGE('Harvest entries Imported sucessfully!');
    end;

    local procedure ProcessXML(xmlDocumentDoc: DotNet DxmlDoc; var ESTXmlBuffer: Record "CBR XML Buffer"; TableID: Integer);
    begin
        InsertLineEntry(ESTXmlBuffer, xmlDocumentDoc, '', TableID);
    end;

    procedure InsertLineEntry(var ESTXmlBuffer: Record "CBR XML Buffer"; _xmlRootNode: DotNet DxmlNode; _xPath: Text[1024]; TableID: Integer);
    var
        _xmlNodeCurr: DotNet DxmlNode;
        _xmlNodeCurrChild: DotNet DxmlNode;
        _xmlText: Text[260];
        i: Integer;
        _currentXPath: Text[1024];
        _nodeValue: Text[1024];
    begin
        _currentXPath += '/' + _xmlRootNode.Name;

        InsertTextLine(ESTXmlBuffer, _xmlRootNode.Name, '', COPYSTR('<' + _xmlRootNode.Name + '>', 1, 250), _xPath,
                       _xmlRootNode.ChildNodes.Count = 0);
        NodeLevel += 1;
        for i := 0 to _xmlRootNode.ChildNodes.Count - 1 do begin
            _xmlNodeCurr := _xmlRootNode.ChildNodes.Item(i);
            _currentXPath := _xPath + '/' + _xmlNodeCurr.Name;
            if _xmlNodeCurr.ChildNodes.Count = 1 then begin
                if _xmlNodeCurr.ChildNodes.Item(0).Name = '#text' then begin
                    _nodeValue := _xmlNodeCurr.ChildNodes.Item(0).Value;
                    InsertTextLine(
                      ESTXmlBuffer,
                      _xmlNodeCurr.Name,
                      COPYSTR(_nodeValue, 1, 249),
                      COPYSTR(
                        '<' +
                        _xmlNodeCurr.Name + '>' +
                        _nodeValue +
                        '</' +
                        _xmlNodeCurr.Name +
                        '>', 1, 249), _currentXPath, true);
                end else begin
                    InsertLineEntry(ESTXmlBuffer, _xmlNodeCurr, _currentXPath, TableID);
                end;
            end else
                InsertLineEntry(ESTXmlBuffer, _xmlNodeCurr, _currentXPath, TableID);
        end;
        NodeLevel -= 1;

        if _xmlRootNode.ChildNodes.Count = 0 then
            InsertTextLine(ESTXmlBuffer, '', '', COPYSTR('</' + _xmlRootNode.Name + '>', 1, 250), _xPath, false)
        else
            InsertTextLine(ESTXmlBuffer, _xmlRootNode.Name, '', COPYSTR('</' + _xmlRootNode.Name + '>', 1, 250), _xPath, false);
    end;

    procedure InsertTextLine(var ESTXmlBuffer: Record "CBR XML Buffer"; _transName: Text[50]; _transValue: Text[1024]; _logText: Text[1024]; _xPath: Text[1024]; _allowEdit: Boolean);
    var
        _delPos: Integer;
        _thisString: Text[30];
        TempValue: Text;
        LineNo: Integer;
    begin
        _delPos := STRPOS(_logText, 'ns0:');

        if _delPos <> 0 then
            _logText := DELSTR(_logText, _delPos, 4);

        _thisString := PADSTR(_thisString, NodeLevel * 2, ' ');

        LineNo += 10;
        with ESTXmlBuffer do begin
            INIT;
            "Session ID" := SESSIONID;
            "Entry No." := "Entry No." + 1;
            "Line No." := LineNo;
            Text := COPYSTR((_thisString + _logText), 1, 250);
            "Extended Text" := COPYSTR((_thisString + _logText), 251, 100);
            Level := NodeLevel;
            Name := _transName;
            Value := COPYSTR(_transValue, 1, 250);
            "Extended Value" := COPYSTR(_transValue, 251, 100);
            if _allowEdit then
                XPath := DELSTR(_xPath, 1, 1);
            INSERT;
        end;
    end;

    local procedure TraverseDaily();
    begin
    end;

    local procedure TraverseTimeEntry();
    begin
    end;

    local procedure Initialization();
    begin
        Day := 0;
        Month := 0;
        Year := 0;
    end;

    // procedure CreateSalesOrder(var CustNo: Code[20]);
    // var
    //     SH: Record "Sales Header";
    //     SL: Record "Sales Line";
    //     LineNo: Integer;
    //     HarvestInvDetails: Record "CAN Harvest Invoice Details";
    //     TempCustNo: Code[20];
    // begin
    //     HarvestInvDetails.RESET;
    //     HarvestInvDetails.SETCURRENTKEY("NAV Customer No.");
    //     HarvestInvDetails.SETRANGE("NAV Customer No.", CustNo);
    //     if HarvestInvDetails.FINDSET then begin
    //         SH.INIT;
    //         SH."Document Type" := SH."Document Type"::Invoice;
    //         SH."No." := '';
    //         SH.INSERT(true);
    //         SH.VALIDATE("Sell-to Customer No.", CustNo);
    //         SH.VALIDATE("Posting Date", HarvestInvDetails."Issue Date");
    //         SH."CAN From Harvest" := true;
    //         SH.MODIFY;
    //         repeat

    //             SL.INIT;
    //             SL.VALIDATE("Document Type", SL."Document Type"::Invoice);
    //             SL.VALIDATE("Document No.", SH."No.");
    //             LineNo += 10000;
    //             SL."Line No." := LineNo;
    //             SL.INSERT(true);
    //             SL.VALIDATE("Sell-to Customer No.", CustNo);
    //             SL.VALIDATE(Type, SL.Type::Resource);
    //             SL.VALIDATE("No.", HarvestInvDetails."Line Item");
    //             SL.Description := COPYSTR(HarvestInvoiceDetails."Line Item Description", 1, 50);
    //             SL."Description 2" := COPYSTR(HarvestInvoiceDetails."Line Item Description", 51, 50);
    //             SL.VALIDATE(Quantity, HarvestInvDetails.Quantity);
    //             SL.VALIDATE("Unit Price", HarvestInvDetails."Unit Price");
    //             SL.MODIFY;
    //         until HarvestInvDetails.NEXT = 0;
    //     end;

    //     //MESSAGE('Sales Invoice %1 has been created',SH."No.");
    // end;

    local procedure UpdateLineItems();
    begin
        I := 1;
        K := 0;
        J := 0;

        TempESTXMLBuffer.RESET;
        TempESTXMLBuffer.SETCURRENTKEY(XPath);
        TempESTXMLBuffer.SETFILTER(XPath, 'root/invoices/id');
        if TempESTXMLBuffer.FINDSET then
            repeat
                EntryNo[I] := TempESTXMLBuffer."Entry No.";
                ProjName[I] := TempESTXMLBuffer.Value;
                I += 1;
            until TempESTXMLBuffer.NEXT = 0;
        //Message(format(K));
        TempESTXMLBuffer.Reset();
        if TempESTXMLBuffer.Find('-') then
            EntryNo[I] := TempESTXMLBuffer.Count();

        for J := 1 to I do begin
            //for J := 1 to K do begin
            TempESTXMLBuffer2.RESET;
            TempESTXMLBuffer2.SETCURRENTKEY("Entry No.");
            TempESTXMLBuffer2.SETRANGE("Entry No.", EntryNo[J], EntryNo[J + 1]);
            if TempESTXMLBuffer2.FINDSET then begin
                TempESTXMLBuffer2.MODIFYALL(SKU, ProjName[J]);
            end;
        end;
    end;

    procedure TraversChildInvoices2();
    var
        LineNo: Integer;
        TextVar: array[5] of Text[1024];
        EntryNo: Integer;
        DecVar: Decimal;
        TempESTXMLBuffer2: Record "CBR XML Buffer";
        NPINoText: Text;
        PeriodstartDate: Date;
        PeriodEndDate: Date;
        ProjctId: Code[20];
        ProjectName: Text;
        ClientID: Code[20];
        ClientName: Text;
        Qty: Decimal;
        UntPric: Decimal;
        Amt: Decimal;
        LineItem: Text;
        LineItmDesc: Text;
        IssuDate: Date;
        DueDate: Date;
        Pymtems: Code[20];
        CurrCode: Code[10];
        PrjCode: Code[20];
        RecHarvestNAVCustMapping: Record "CBR Harvest NAV Cust Mapping";
        EndStringPos: Integer;
        Trim1: Text[250];
        Trim2: Text[250];
        Trim3: Text[250];
        Trim4: Text[250];
        RecResource: Record Resource;
        RecBaseUnitofMeasure: Record "Resource Unit of Measure";
        HarvestSetup: Record "CBR Harvest Setup";
        FindLineDescriptionNo: Integer;
        FindQtyLineNo: Integer;
        FindAmtLineNo: Integer;
        FindUnitPriceLineNo: Integer;
    begin
        TempESTXMLBuffer2.RESET;
        TempESTXMLBuffer2.SETCURRENTKEY(XPath);
        TempESTXMLBuffer2.SETFILTER(XPath, '%1', 'root/invoices/line_items/id');
        if TempESTXMLBuffer2.FINDSET then
            repeat
                HarvestInvoiceDetails.INIT;
                HarvestInvoiceDetails."Invoice Entry No" += 1;
                HarvestInvoiceDetails."Line Item" := TempESTXMLBuffer2.Value;
                HarvestInvoiceDetails."Invoice ID." := TempESTXMLBuffer2.SKU;
                HarvestInvoiceDetails.INSERT;
            until TempESTXMLBuffer2.NEXT = 0;

        HarvestInvoiceDetails.RESET;
        HarvestInvoiceDetails.SETCURRENTKEY("Invoice ID.");
        if HarvestInvoiceDetails.FINDSET then
            repeat
                TempESTXMLBuffer.RESET;
                TempESTXMLBuffer.SETCURRENTKEY(SKU);
                TempESTXMLBuffer.SETFILTER(SKU, '%1', HarvestInvoiceDetails."Invoice ID.");
                if TempESTXMLBuffer.FINDSET then
                    repeat
                        case TempESTXMLBuffer.XPath of
                            'root/invoices/period_start'://
                                begin
                                    if TempESTXMLBuffer.Value <> '' then begin
                                        Initialization;
                                        EVALUATE(Day, COPYSTR(TempESTXMLBuffer.Value, 9, 2));
                                        EVALUATE(Month, COPYSTR(TempESTXMLBuffer.Value, 6, 2));
                                        EVALUATE(Year, COPYSTR(TempESTXMLBuffer.Value, 1, 4));
                                        PeriodstartDate := DMY2DATE(Day, Month, Year);
                                        HarvestInvoiceDetails."Period Start Date" := PeriodstartDate;
                                        HarvestInvoiceDetails.MODIFY;
                                    end;
                                end;

                            'root/invoices/period_end': //
                                begin
                                    if TempESTXMLBuffer.Value <> '' then begin
                                        Initialization;
                                        EVALUATE(Day, COPYSTR(TempESTXMLBuffer.Value, 9, 2));
                                        EVALUATE(Month, COPYSTR(TempESTXMLBuffer.Value, 6, 2));
                                        EVALUATE(Year, COPYSTR(TempESTXMLBuffer.Value, 1, 4));
                                        PeriodEndDate := DMY2DATE(Day, Month, Year);
                                        HarvestInvoiceDetails."Period End Date" := PeriodEndDate;
                                        HarvestInvoiceDetails.MODIFY;
                                    end;
                                end;
                            'root/invoices/issue_date': //
                                begin
                                    if TempESTXMLBuffer.Value <> '' then begin
                                        Initialization;
                                        EVALUATE(Day, COPYSTR(TempESTXMLBuffer.Value, 9, 2));
                                        EVALUATE(Month, COPYSTR(TempESTXMLBuffer.Value, 6, 2));
                                        EVALUATE(Year, COPYSTR(TempESTXMLBuffer.Value, 1, 4));
                                        IssuDate := DMY2DATE(Day, Month, Year);
                                        HarvestInvoiceDetails."Issue Date" := IssuDate;
                                        HarvestInvoiceDetails.MODIFY;
                                    end;
                                end;
                            'root/invoices/due_date': //
                                begin
                                    if TempESTXMLBuffer.Value <> '' then begin
                                        Initialization;
                                        EVALUATE(Day, COPYSTR(TempESTXMLBuffer.Value, 9, 2));
                                        EVALUATE(Month, COPYSTR(TempESTXMLBuffer.Value, 6, 2));
                                        EVALUATE(Year, COPYSTR(TempESTXMLBuffer.Value, 1, 4));
                                        DueDate := DMY2DATE(Day, Month, Year);
                                        HarvestInvoiceDetails."Due Date" := DueDate;
                                        HarvestInvoiceDetails.MODIFY;
                                    end;
                                end;
                            'root/invoices/payment_term': //
                                begin
                                    Pymtems := TempESTXMLBuffer.Value;
                                    HarvestInvoiceDetails."Payment Terms" := Pymtems;
                                    HarvestInvoiceDetails.MODIFY;
                                end;

                            'root/invoices/currency': //
                                begin
                                    CurrCode := TempESTXMLBuffer.Value;
                                    HarvestInvoiceDetails."Currency Code" := CurrCode;
                                    HarvestInvoiceDetails.MODIFY;
                                end;
                            'root/invoices/client/name': //
                                begin
                                    ClientName := TempESTXMLBuffer.Value;
                                    HarvestInvoiceDetails."Client Name" := ClientName;
                                    HarvestInvoiceDetails.MODIFY;
                                end;
                            'root/invoices/line_items/id': //
                                begin
                                    Clear(LineItem);
                                    LineItem := TempESTXMLBuffer.Value;
                                    // HarvestInvoiceDetails."Line Item" := LineItem;
                                    if HarvestInvoiceDetails."Line Item" = LineItem then begin
                                        FindLineDescriptionNo := TempESTXMLBuffer."Entry No." + 2;
                                        if TempESTXMLBuffer2.Get(FindLineDescriptionNo, TempESTXMLBuffer."Line No.") then
                                            HarvestInvoiceDetails."Line Item Description" := copystr(TempESTXMLBuffer2.Value, 1, 250);
                                        //==================
                                        Trim1 := DelStr(HarvestInvoiceDetails."Line Item Description", 1, StrPos(HarvestInvoiceDetails."Line Item Description", '/'));
                                        Trim2 := DelStr(Trim1, 1, StrPos(Trim1, '/'));
                                        Trim3 := DelStr(Trim2, 1, StrPos(Trim2, '/'));
                                        Trim4 := CopyStr(Trim3, 2, StrPos(Trim3, ':'));
                                        HarvestInvoiceDetails."Resouce Name" := DelChr(Trim4, '=', ':');
                                        if HarvestInvoiceDetails."Resouce Name" <> '' then begin
                                            RecResource.Reset();
                                            RecResource.SetFilter(Name, HarvestInvoiceDetails."Resouce Name");
                                            if RecResource.FindFirst() then begin
                                                HarvestInvoiceDetails."Resource No." := RecResource."No.";
                                            end else begin
                                                RecResource.Init();
                                                RecResource."No." := '';
                                                RecResource.Name := HarvestInvoiceDetails."Resouce Name";
                                                RecResource.Type := RecResource.Type::Person;
                                                RecResource."Gen. Prod. Posting Group" := 'NO TAX';
                                                RecResource."Base Unit of Measure" := 'HOUR';
                                                RecResource.Insert(true);
                                                HarvestInvoiceDetails."Resource No." := RecResource."No.";
                                                RecBaseUnitofMeasure.Init();
                                                RecBaseUnitofMeasure."Resource No." := RecResource."No.";
                                                RecBaseUnitofMeasure.Code := 'HOUR';
                                                RecBaseUnitofMeasure."Qty. per Unit of Measure" := 1;
                                                RecBaseUnitofMeasure."Related to Base Unit of Meas." := true;
                                                RecBaseUnitofMeasure.Insert();
                                            end;
                                        end;
                                        //CAN_PS 18042019 START
                                        if HarvestInvoiceDetails."Resouce Name" = '' then begin
                                            Trim1 := CopyStr(TempESTXMLBuffer2.Value, 1, StrPos(TempESTXMLBuffer2.Value, ' '));
                                            Trim1 := '@*' + Trim1 + '*';
                                            RecResource.Reset();
                                            RecResource.SetFilter(Name, Trim1);
                                            if RecResource.FindFirst() then begin
                                                HarvestInvoiceDetails.validate("Resource No.", RecResource."No.");
                                                HarvestInvoiceDetails.Modify();
                                            end;
                                        end;
                                        //CAN_PS 18042019 STOP
                                        //CAN_PS 08042019 START
                                        if HarvestInvoiceDetails."Resouce Name" = '' then begin
                                            if HarvestSetup.Get() then
                                                HarvestInvoiceDetails."Resource No." := HarvestSetup."Default Resource No.";
                                        end;
                                        Clear(FindQtyLineNo);
                                        Clear(Qty);
                                        FindQtyLineNo := TempESTXMLBuffer."Entry No." + 3;
                                        if TempESTXMLBuffer2.Get(FindQtyLineNo, TempESTXMLBuffer."Line No.") then begin
                                            EVALUATE(Qty, TempESTXMLBuffer2.Value);
                                            HarvestInvoiceDetails.Quantity := Qty;
                                        end;
                                        Clear(FindUnitPriceLineNo);
                                        Clear(UntPric);
                                        FindUnitPriceLineNo := TempESTXMLBuffer."Entry No." + 4;
                                        if TempESTXMLBuffer2.Get(FindUnitPriceLineNo, TempESTXMLBuffer."Line No.") then begin
                                            EVALUATE(UntPric, TempESTXMLBuffer2.Value);
                                            HarvestInvoiceDetails."Unit Price" := UntPric;
                                        end;
                                        Clear(FindAmtLineNo);
                                        Clear(Amt);
                                        FindAmtLineNo := TempESTXMLBuffer."Entry No." + 5;
                                        if TempESTXMLBuffer2.Get(FindAmtLineNo, TempESTXMLBuffer."Line No.") then begin
                                            EVALUATE(Amt, TempESTXMLBuffer2.Value);
                                            HarvestInvoiceDetails.Amount := Amt;
                                        end;
                                        //CAN_PS 08042019 STOP
                                        //==================
                                    end;
                                    HarvestInvoiceDetails.MODIFY;

                                end;

                            'root/invoices/line_items/kind': //
                                begin

                                end;

                            //CAN_PS 14042019 START
                            'root/invoices/number':
                                begin
                                    HarvestInvoiceDetails."Invoice No" := copystr(TempESTXMLBuffer.Value, 1, 20);
                                    HarvestInvoiceDetails.MODIFY;
                                end;
                            'root/invoices/client/id':
                                begin
                                    HarvestInvoiceDetails."Harvest Client ID" := copystr(TempESTXMLBuffer.Value, 1, 20);
                                    //CAN_PS 04162019 START
                                    if RecHarvestNAVCustMapping.Get(HarvestInvoiceDetails."Harvest Client ID") then
                                        HarvestInvoiceDetails."NAV Customer No." := RecHarvestNAVCustMapping."NAV Customer No."
                                    else begin
                                        RecHarvestNAVCustMapping.Init();
                                        RecHarvestNAVCustMapping."Client ID" := HarvestInvoiceDetails."Harvest Client ID";
                                        RecHarvestNAVCustMapping."Client Name" := HarvestInvoiceDetails."Client Name";
                                        RecHarvestNAVCustMapping.Insert();
                                    end;
                                    //CAN_PS 04162019 STOP
                                    HarvestInvoiceDetails.MODIFY;
                                end;
                            //CAN_PS 14042019 STOP

                            // 'root/invoices/line_items/description': //
                            //     begin
                            //         Clear(LineItmDesc);
                            //         LineItmDesc := TempESTXMLBuffer.Value;
                            //         HarvestInvoiceDetails."Line Item Description" := COPYSTR(LineItmDesc, 1, 250);
                            //         HarvestInvoiceDetails.MODIFY;
                            //         Trim1 := DelStr(LineItmDesc, 1, StrPos(LineItmDesc, '/'));
                            //         Trim2 := DelStr(Trim1, 1, StrPos(Trim1, '/'));
                            //         Trim3 := DelStr(Trim2, 1, StrPos(Trim2, '/'));
                            //         Trim4 := CopyStr(Trim3, 2, StrPos(Trim3, ':'));
                            //         HarvestInvoiceDetails."Resouce Name" := DelChr(Trim4, '=', ':');
                            //         if HarvestInvoiceDetails."Resouce Name" <> '' then begin
                            //             RecResource.Reset();
                            //             RecResource.SetFilter(Name, HarvestInvoiceDetails."Resouce Name");
                            //             if RecResource.FindFirst() then begin
                            //                 HarvestInvoiceDetails."Resource No." := RecResource."No.";
                            //             end else begin
                            //                 RecResource.Init();
                            //                 RecResource."No." := '';
                            //                 RecResource.Name := HarvestInvoiceDetails."Resouce Name";
                            //                 RecResource.Type := RecResource.Type::Person;
                            //                 RecResource."Gen. Prod. Posting Group" := 'NO TAX';
                            //                 RecResource."Base Unit of Measure" := 'HOUR';
                            //                 RecResource.Insert(true);
                            //                 HarvestInvoiceDetails."Resource No." := RecResource."No.";
                            //                 RecBaseUnitofMeasure.Init();
                            //                 RecBaseUnitofMeasure."Resource No." := RecResource."No.";
                            //                 RecBaseUnitofMeasure.Code := 'HOUR';
                            //                 RecBaseUnitofMeasure."Qty. per Unit of Measure" := 1;
                            //                 RecBaseUnitofMeasure."Related to Base Unit of Meas." := true;
                            //                 RecBaseUnitofMeasure.Insert();
                            //             end;
                            //         end;
                            //         //CAN_PS 08042019 START
                            //         if HarvestInvoiceDetails."Resouce Name" = '' then begin
                            //             if HarvestSetup.Get() then
                            //                 HarvestInvoiceDetails."Resource No." := HarvestSetup."Default Resource No.";
                            //         end;
                            //         //CAN_PS 08042019 STOP
                            //         HarvestInvoiceDetails.Modify;
                            //     end;

                            // 'root/invoices/line_items/quantity': //
                            //     begin
                            //         EVALUATE(Qty, TempESTXMLBuffer.Value);
                            //         HarvestInvoiceDetails.Quantity := Qty;
                            //         HarvestInvoiceDetails.MODIFY;
                            //     end;
                            // 'root/invoices/line_items/unit_price': //
                            //     begin
                            //         EVALUATE(UntPric, TempESTXMLBuffer.Value);
                            //         HarvestInvoiceDetails."Unit Price" := UntPric;
                            //         HarvestInvoiceDetails.MODIFY;
                            //     end;

                            // 'root/invoices/line_items/amount': //
                            //     begin
                            //         EVALUATE(Amt, TempESTXMLBuffer.Value);
                            //         HarvestInvoiceDetails.Amount := Amt;
                            //         HarvestInvoiceDetails.MODIFY;
                            //     end;
                            'root/invoices/line_items/project/id': //
                                begin
                                    ProjctId := TempESTXMLBuffer.Value;
                                    HarvestInvoiceDetails."Project ID" := ProjctId;
                                    HarvestInvoiceDetails.MODIFY;
                                end;

                            'root/invoices/line_items/project/name': //
                                begin
                                    ProjectName := TempESTXMLBuffer.Value;
                                    HarvestInvoiceDetails."Project Name" := ProjectName;
                                    HarvestInvoiceDetails.MODIFY;
                                end;

                            'root/invoices/line_items/project/code': //
                                begin
                                    PrjCode := TempESTXMLBuffer.Value;

                                end;
                        end;
                    until TempESTXMLBuffer.NEXT = 0;
            until HarvestInvoiceDetails.NEXT = 0;
        //CAN_PS START 08042019
        if (GStartDate <> 0D) and (GEndDate <> 0D) then begin
            HarvestInvoiceDetails.Reset();
            HarvestInvoiceDetails.SetFilter("Issue Date", '<%1', GStartDate);
            if HarvestInvoiceDetails.FindSet() then
                HarvestInvoiceDetails.DeleteAll();

            HarvestInvoiceDetails.Reset();
            HarvestInvoiceDetails.SetFilter("Issue Date", '>%1', GEndDate);
            if HarvestInvoiceDetails.FindSet() then
                HarvestInvoiceDetails.DeleteAll();
        end;
        //CAN_PS STOP 08042019
    end;
}

