dotnet
{
    assembly(System)
    {
        type(System.Net.HttpWebRequest; DWebRequest) { }
        type(System.Net.CookieContainer; DCookieContainer) { }
        //type(System.Xml.XmlNode; RootNode) { }
        type(System.Net.HttpWebResponse; DWebResponse) { }
        type(System.Collections.Specialized.NameValueCollection; DResponseHeader) { }
        type(System.Net.HttpStatusCode; DHttpStatusCode) { }

    }
    assembly(Newtonsoft.Json)
    {
        type(Newtonsoft.Json.Linq.JObject; DJObjects) { }
        type(Newtonsoft.Json.JsonConvert; DJsonConvert) { }
    }
    assembly(System.Xml)
    {
        type(System.Xml.XmlDocument; DxmlDoc) { }
        type(System.Xml.XmlNode; DxmlNode) { }
        type(System.Xml.XmlNodeList; DxmlNodelist) { }
    }

}