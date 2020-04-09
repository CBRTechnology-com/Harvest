
codeunit 50020 HarvestIntegration
{
    trigger OnRun()
    begin

    end;

    procedure GetProducts()
    var
        Arguments: Record "CBR RESTWebServiceArguments" temporary;
        Response: JsonObject;
        JToken: JsonToken;
        DataArray: JsonArray;
        Data: JsonObject;
        RequestContent: HttpContent;
        RequestHeaders: HttpHeaders;
        ErrGetProductsFailed: Label 'Could not get response from the harvest';
    begin
        // InitArguments(Arguments);
        // Arguments.RestMethod := Arguments.RestMethod::get;
        // RequestContent.GetHeaders(RequestHeaders);
        // RequestHeaders.Remove('Content-Type');

        // RequestHeaders.Add('Harvest-Account-Id', '1078720');
        // RequestHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        // //Arguments.SetRequestContent(RequestContent);
        // if not CallWebService(Arguments) then
        //     Error('%1\\%2', ErrGetProductsFailed, Arguments.GetResponseContentAsText());

        // // StripeProduct.Reset();
        // // StripeProduct.DeleteAll();
        // Message(Arguments.GetResponseContentAsText());

        // Response.ReadFrom(Arguments.GetResponseContentAsText());
        // Response.Get('data', JToken);
        // DataArray := JToken.AsArray();
        // foreach JToken in DataArray do begin
        //     Data := JToken.AsObject();
        //     // StripeProduct.Init();
        //     ;
        //     // StripeProduct.PopulateFromJson(Data);
        //     // StripeProduct.Insert();
        // end;
        //****
        Str := '<Canarys><Employees><Employee>Sainath</Employee><Employee>Sandeep</Employee><Employee>Subhash</Employee></Employees></Canarys>';
        // XmlDoc := XmlDocument.Create();
        // //jsonTest:=ALI Call;
        // // jsonTest.WriteTo(Str);
        // ResponseXMlDoc := XmlDocument.Create();
        XmlDocument.ReadFrom(Str, ResponseXMlDoc);
        //XMlDoc.GetDocument(ResponseXMlDoc);


        //XMlDoc.SelectSingleNode('/Canarys/Employees/Employee', XMLNoderesponse);

        IF XMlDoc.SelectNodes('//Canarys/Employees', lXmlNodeList) then begin
            foreach XMLNoderesponse in lXmlNodeList do begin
                IF XMLNoderesponse.SelectSingleNode('Employee', lXmlNode) then
                    EmpName := lXmlNode.AsXmlElement.InnerText;
                Message(EmpName);
                // IF XMLNoderesponse.SelectSingleNode('LastName', lXmlNode) then
                //     LastName := lXmlNode.AsXmlElement.InnerText;
            end;
        end;


        //***
    end;

    local procedure InitArguments(var Arguments: Record "CBR RESTWebServiceArguments" temporary)
    begin
        Arguments.URL := GetBaseUrl();
        Arguments.UserName := GetSecretKey();
        //rguments.Insert();
    end;

    local procedure CallWebService(var Arguments: Record "CBR RESTWebServiceArguments" temporary) Success: Boolean
    var
        RESTWebService: codeunit "CBR RESTWebServiceCode";
    begin
        Success := RESTWebService.CallHarvestRESTWebService(Arguments);

    end;

    local procedure GetBaseUrl(): Text
    begin
        exit('https://api.harvestapp.com/v2/invoices');
    end;

    local procedure GetSecretKey(): Text
    begin
        exit('1893586.pt.DAFyrzCx9FuIWK4Kc9dJfTJjlegDulz0iQpZsh5KJzW6OMhDmJQ9bOF6mL1VcBKn4xPG8EsoYH5hET4BmLVRcQ');
    end;


    var
        myInt: Integer;
        XMlDoc: XMLDocument;
        ResponseXMlDoc: XMLDocument;
        Str: Text;
        jsonTest: JsonObject;
        XMLNoderesponse: XmlNode;
        XElement: XmlElement;
        lXmlNodeList: XmlNodeList;
        lText: Text;
        lXmlNode: XMLNode;
        EmpName: Text;
}