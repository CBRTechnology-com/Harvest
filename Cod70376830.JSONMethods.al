codeunit 50005 "CBR JSONMethods"
{
    var
        JObject: JsonObject;
        JsonTokenNotFoundErr: Label 'Could not find JsonToken %1';
        JsonTokenIsNotValueErr: Label 'The Json object is malformed. Could not find Json value %1';

    procedure GetJsonValue(Property: Text): JsonValue
    var
        JToken: JsonToken;
    begin
        if not JObject.Get(Property, JToken) then
            Error(JsonTokenNotFoundErr, Property);

        if not JToken.IsValue() then
            Error(JsonTokenIsNotValueErr, Property);

        exit(JToken.AsValue());
    end;

    procedure SelectJsonValue(Path: Text): JsonValue
    var
        JToken: JsonToken;
    begin
        if not JObject.SelectToken(Path, JToken) then
            Error(JsonTokenNotFoundErr, Path);

        if not JToken.IsValue() then
            Error(JsonTokenIsNotValueErr, Path);

        exit(JToken.AsValue());
    end;

    procedure IsNullValue(Property: Text) Result: Boolean
    var
        JToken: JsonToken;
        JValue: JsonValue;
    begin
        if not JObject.Get(Property, JToken) then
            exit;

        JValue := JToken.AsValue();
        Result := JValue.IsNull() or JValue.IsUndefined();
    end;

    procedure ReadFromText(Data: Text)
    begin
        Clear(JObject);
        JObject.ReadFrom(Data);
    end;

    procedure SetJsonObject(var Value: JsonObject)
    begin
        JObject := Value;
    end;

}