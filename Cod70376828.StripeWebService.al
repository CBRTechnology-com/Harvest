codeunit 50003 "CBR StripeWebService"
{
    procedure CreateCustomer(var StripeCust: Record "CBR StripeCustomer")
    var
        Arguments: Record "CBR RESTWebServiceArguments" temporary;
        RequestContent: HttpContent;
        RequestHeaders: HttpHeaders;
        Response: JsonObject;
        ErrCreateCustomerFailed: Label 'Creation of customer failed.';
    begin
        InitArguments(Arguments, 'customers');
        Arguments.RestMethod := Arguments.RestMethod::post;

        RequestContent.WriteFrom(StripeCust.GetAsFormData());

        RequestContent.GetHeaders(RequestHeaders);
        RequestHeaders.Remove('Content-Type');
        RequestHeaders.add('Content-Type', 'application/x-www-form-urlencoded');
        Arguments.SetRequestContent(RequestContent);
        if not CallWebService(Arguments) then
            Error('%1\\%2', ErrCreateCustomerFailed, Arguments.GetResponseContentAsText());

        Response.ReadFrom(Arguments.GetResponseContentAsText());
        StripeCust.PopulateFromJson(Response);
    end;

    procedure UpdateCustomer(var StripeCust: Record "CBR StripeCustomer")
    var
        Arguments: Record "CBR RESTWebServiceArguments" temporary;
        RequestContent: HttpContent;
        RequestHeaders: HttpHeaders;
        Response: JsonObject;
        UpdateCustomerFailedErr: Label 'Update of customer failed.';
    begin
        InitArguments(Arguments, StrSubstNo('customers/%1', StripeCust.Id));
        Arguments.RestMethod := Arguments.RestMethod::post;

        RequestContent.WriteFrom(StripeCust.GetAsFormData());


        RequestContent.GetHeaders(RequestHeaders);
        RequestHeaders.Remove('Content-Type');
        RequestHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        Arguments.SetRequestContent(RequestContent);
        if not CallWebService(Arguments) then
            Error('%1\\%2', UpdateCustomerFailedErr, Arguments.GetResponseContentAsText());

        Response.ReadFrom(Arguments.GetResponseContentAsText());
        StripeCust.PopulateFromJson(Response);
        StripeCust.Modify();
    end;

    procedure GetProducts(var StripeProduct: Record "CBR StripeProduct")
    var
        Arguments: Record "CBR RESTWebServiceArguments" temporary;
        Response: JsonObject;
        JToken: JsonToken;
        DataArray: JsonArray;
        Data: JsonObject;
        ErrGetProductsFailed: Label 'Could not get available products';
    begin
        InitArguments(Arguments, 'products');
        Arguments.RestMethod := Arguments.RestMethod::get;
        if not CallWebService(Arguments) then
            Error('%1\\%2', ErrGetProductsFailed, Arguments.GetResponseContentAsText());

        StripeProduct.Reset();
        StripeProduct.DeleteAll();

        Response.ReadFrom(Arguments.GetResponseContentAsText());
        Response.Get('data', JToken);
        DataArray := JToken.AsArray();
        foreach JToken in DataArray do begin
            Data := JToken.AsObject();
            StripeProduct.Init();
            ;
            StripeProduct.PopulateFromJson(Data);
            StripeProduct.Insert();
        end;
    end;

    procedure GetPlans(var StripePlan: Record "CBR StripePlan")
    var
        Arguments: Record "CBR RESTWebServiceArguments" temporary;
        Response: JsonObject;
        JToken: JsonToken;
        DataArray: JsonArray;
        Data: JsonObject;
        ErrGetPlansFailed: Label 'Could not get available plans';
    begin
        InitArguments(Arguments, 'plans');
        Arguments.RestMethod := Arguments.RestMethod::get;
        if not CallWebService(Arguments) then
            Error('%1\\%2', ErrGetPlansFailed, Arguments.GetResponseContentAsText());

        StripePlan.Reset();
        StripePlan.DeleteAll();

        Response.ReadFrom(Arguments.GetResponseContentAsText());
        Response.Get('data', JToken);
        DataArray := JToken.AsArray();
        foreach JToken in DataArray do begin
            Data := JToken.AsObject();
            StripePlan.Init();
            StripePlan.PopulateFromJson(Data);
            StripePlan.Insert();
        end;

    end;

    procedure CreateSubscription(StripeCust: Record "CBR StripeCustomer"; StripePlan: Record "CBR StripePlan"; var StripeSubscription: Record "CBR StripeSubscription")
    var
        Arguments: Record "CBR RESTWebServiceArguments" temporary;
        RequestContent: HttpContent;
        RequestHeaders: HttpHeaders;
        Response: JsonObject;
        CreateSubscriptionFailedErr: Label 'Could not create subscription';
    begin
        InitArguments(Arguments, 'subscriptions');
        Arguments.RestMethod := Arguments.RestMethod::post;

        RequestContent.WriteFrom(StripeSubscription.GetFormDataForCreateSubscription(StripePlan, StripeCust));

        RequestContent.GetHeaders(RequestHeaders);
        RequestHeaders.Remove('Content-Type');
        RequestHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        Arguments.SetRequestContent(RequestContent);
        if not CallWebService(Arguments) then
            Error('%1\\%2', CreateSubscriptionFailedErr, Arguments.GetResponseContentAsText());

        Response.ReadFrom(Arguments.GetResponseContentAsText());

        StripeSubscription.Init();
        StripeSubscription.PopulateFromJson(Response);
        StripeSubscription.Insert();
    end;

    procedure UpdateSubscription(StripePlan: Record "CBR StripePlan"; var StripeSubscription: Record "CBR StripeSubscription")
    var
        Arguments: Record "CBR RESTWebServiceArguments" temporary;
        RequestContent: HttpContent;
        RequestHeaders: HttpHeaders;
        Response: JsonObject;
        ErrCreateSubscriptionFailed: Label 'Could not update subscription';
    begin
        InitArguments(Arguments, StrSubstNo('subscriptions/%1', StripeSubscription.Id));
        Arguments.RestMethod := Arguments.RestMethod::post;

        RequestContent.WriteFrom(StripeSubscription.GetFormDataForUpdateSubscription(StripePlan));


        RequestContent.GetHeaders(RequestHeaders);
        RequestHeaders.Remove('Content-Type');
        RequestHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');
        Arguments.SetRequestContent(RequestContent);
        if not CallWebService(Arguments) then
            Error('%1\\%2', ErrCreateSubscriptionFailed, Arguments.GetResponseContentAsText());

        Response.ReadFrom(Arguments.GetResponseContentAsText());

        StripeSubscription.PopulateFromJson(Response);
        StripeSubscription.Modify();
    end;

    procedure RefreshSubscription(var StripeSubscription: Record "CBR StripeSubscription")
    var
        Arguments: Record "CBR RESTWebServiceArguments" temporary;
        ErrGetSubscriptionFailed: Label 'Could not get subscription';
        Response: JsonObject;
    begin
        InitArguments(Arguments, StrSubstNo('subscriptions/%1', StripeSubscription.Id));
        Arguments.RestMethod := Arguments.RestMethod::get;

        if not CallWebService(Arguments) then
            Error('%1\\%2', ErrGetSubscriptionFailed, Arguments.GetResponseContentAsText());

        Response.ReadFrom(Arguments.GetResponseContentAsText());

        StripeSubscription.PopulateFromJson(Response);
        StripeSubscription.Modify();
    end;

    local procedure CallWebService(var Arguments: Record "CBR RESTWebServiceArguments" temporary) Success: Boolean
    var
        RESTWebService: codeunit "CBR RESTWebServiceCode";
    begin
        Success := RESTWebService.CallRESTWebService(Arguments);
    end;

    local procedure InitArguments(var Arguments: Record "CBR RESTWebServiceArguments" temporary; Method: Text)
    begin
        Arguments.URL := GetBaseUrl() + Method;
        Arguments.UserName := GetSecretKey();
    end;

    local procedure GetBaseUrl(): Text
    begin
        exit('https://api.stripe.com/v1/');
    end;

    local procedure GetSecretKey(): Text
    begin
        exit('sk_test_1DuwPaFOjqxUV6vxpmxjX9jn007SrdH8EW');
    end;
}