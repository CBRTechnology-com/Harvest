codeunit 50004 "CBR RESTWebServiceCode"
{
    procedure CallRESTWebService(var Parameters: Record "CBR RESTWebServiceArguments"): Boolean
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        AuthText: text;
        TempBlob: Record TempBlob temporary;
    begin
        RequestMessage.Method := Format(Parameters.RestMethod);
        RequestMessage.SetRequestUri(Parameters.URL);

        RequestMessage.GetHeaders(Headers);

        if Parameters.Accept <> '' then
            Headers.Add('Accept', Parameters.Accept);

        if Parameters.UserName <> '' then begin
            AuthText := StrSubstNo('%1:%2', Parameters.UserName, Parameters.Password);
            TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
            Headers.Add('Authorization', StrSubstNo('Basic %1', TempBlob.ToBase64String()));
        end;


        if Parameters.ETag <> '' then
            Headers.Add('If-Match', Parameters.ETag);

        if Parameters.HasRequestContent() then begin
            Parameters.GetRequestContent(Content);
            RequestMessage.Content := Content;
        end;
        AllowHttpsClient();
        Client.Send(RequestMessage, ResponseMessage);


        Headers := ResponseMessage.Headers();
        Parameters.SetResponseHeaders(Headers);

        Content := ResponseMessage.Content();
        Parameters.SetResponseContent(Content);

        EXIT(ResponseMessage.IsSuccessStatusCode());
    end;

    procedure CallHarvestRESTWebService(var Parameters: Record "CBR RESTWebServiceArguments"): Boolean
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        AuthText: text;
        TempBlob: Record TempBlob temporary;
    begin
        RequestMessage.Method := Format(Parameters.RestMethod);
        RequestMessage.SetRequestUri(Parameters.URL);

        RequestMessage.GetHeaders(Headers);

        if Parameters.Accept <> '' then
            Headers.Add('Accept', Parameters.Accept);

        if Parameters.UserName <> '' then begin
            //AuthText := StrSubstNo('%1:%2', Parameters.UserName, Parameters.Password);
            AuthText := Parameters.UserName;
            TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
            Headers.Add('Authorization', StrSubstNo('Bearer %1', TempBlob.ToBase64String()));
        end;


        if Parameters.ETag <> '' then
            Headers.Add('If-Match', Parameters.ETag);

        if Parameters.HasRequestContent() then begin
            Parameters.GetRequestContent(Content);
            RequestMessage.Content := Content;
        end;
        AllowHttpsClient();
        Client.Send(RequestMessage, ResponseMessage);


        Headers := ResponseMessage.Headers();
        Parameters.SetResponseHeaders(Headers);

        Content := ResponseMessage.Content();
        Parameters.SetResponseContent(Content);

        EXIT(ResponseMessage.IsSuccessStatusCode());
    end;

    local procedure AllowHttpsClient()
    var
        NAVAppSetting: Record "NAV App Setting";
        TenantManagement: Codeunit "Tenant Management";
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);

        if TenantManagement.IsSandbox() then begin
            NAVAppSetting."App ID" := AppInfo.Id();
            NAVAppSetting."Allow HttpClient Requests" := true;
            if not NAVAppSetting.Insert() then
                NAVAppSetting.Modify();
        end;
    end;
}

