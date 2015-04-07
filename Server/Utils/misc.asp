<%
//location.hostname returns the domain name of the web host
//location.pathname returns the path and filename of the current page
//location.port returns the port of the web host (80 or 443)
//location.protocol returns the web protocol used (http:// or https://)


var location = (function() {
    //Private vars
    var url = Request.ServerVariables.Item("QUERY_STRING").Item.replace("404;", "");
    //fix- replace port if port==':80/'
    //url = url.replace(':80/','/');
    
    //split url onto the origin and pathname, with third dash (/)
    var pathcrumbs = url.split('/');
    //there should be at least 2 pathcrumbs
    var pathname = pathcrumbs.slice(0,3).join('/');
    var origin ='';
    if (pathcrumbs.length>3){
        origin = '/' + pathcrumbs.slice(3).join('/');
    }    
    var hash = '';
    if (url.indexOf('#') != -1) {
            hash =  url.substring(url.indexOf('#'));
    }
    var protocol = url.toLowerCase().match('https:');
    if (protocol==null) {protocol='http:';}
    
    var host = pathname.replace(protocol + '//' , '');
    var port = '';
    if (host.indexOf(':') != -1) {
        port =  host.substring(host.indexOf(':')+1)
    }
    return {
        //Public vars/methods
        href: url,
        pathname : pathname,
        origin : origin,
        hash : hash
    }
})();

function isInt(n) {
   return ((typeof (n.valueOf()) === 'number') && ((n % 1) == 0));
}

String.prototype.format = function(o)
{
    return this.replace(/{([^{}]*)}/g,
       function(a, b)
       {
           var r = o[b];
           return typeof r === 'string' ? r : a;
       }
    );
}

function SanitizeRequest(){
    //rewrite the Requst.Form
    var sRequest = {Cookies:{}, Form:{}, QueryString:{}};
    //skip some URLs, e.g. Request.BinaryRead(count)
    var url = location.href.replace(':80/','/').replace(':443/','/');
    var skipURL = baseurl + "/someSpecialUrl";
    if (url.indexOf(skipURL)==0)
        return true;
    
    var decodedForm = decodeURI(Request.Form.Item).split("&");

    var fld;
    var arrayLength = decodedForm.length;
    for (var i = 0; i < arrayLength; i++) {
        fld = decodedForm[i].split('=');
        if (fld.length==2){
            var fldName = fld[0];
            var fldValue =  unescape(fld[1].replace(/\+/g,' '));
            sRequest.Form[fldName] = fldValue;
        }
    }
    /*
    for(f = new Enumerator(Request.Form); !f.atEnd(); f.moveNext()) 
    { 
        //check the length of every 
        var x = f.item(); 
        //escape the text values
        sRequest.Form[x] = validator.escape(Request.Form(x).Item);
    } 
    */    for(f = new Enumerator(Request.Cookies); !f.atEnd(); f.moveNext()) 
    { 
        //check the length of every 
        var x = f.item(); 
        //escape the text values
        sRequest.Cookies[x] = validator.escape(Request.Cookies(x).Item);
    } 
    for(f = new Enumerator(Request.QueryString); !f.atEnd(); f.moveNext()) 
    { 
        //check the length of every 
        var x = f.item(); 
        //escape the text values
        sRequest.QueryString[x] = validator.escape(Request.QueryString(x).Item);
    } 

    return sRequest;    
}

function createobject(ProgId){
	if ((typeof(Server)=="undefined")&&(typeof(WScript)=="object")){
		return WScript.CreateObject(ProgId);
	}
	else if ((typeof(WScript)=="undefined")&&(typeof(Server)=="object")){
		return Server.CreateObject(ProgId);
	}
}

function ByteArray2Text(varByteArray){
    //Convert byte array into a string with ADODB.Recordset
    var objBinStream;
    var adTypeText = 2;
    var adTypeBinary = 1;
    objBinStream = createobject("ADODB.Stream");
    objBinStream.Type = adTypeBinary;
    objBinStream.Open();
    objBinStream.Write (varByteArray);
    objBinStream.position = 0;
    objBinStream.Type = adTypeText;
    objBinStream.CharSet = "us-ascii";
    var retvalue = objBinStream.ReadText();
    objBinStream.Close();
    objBinStream = null;
    return retvalue;
}

function log(message){
    var isLogEnabled = false;
    if(typeof(config.isLogEnabled)!='undefined')
        isLogEnabled = config.isLogEnabled ;
        
    if (isLogEnabled){    
        var fsoForAppend = 8;
        var logname = Server.MapPath("App_Data/log.txt");
        var objFSO = createobject("Scripting.FileSystemObject");
        if (!(objFSO.FileExists(logname))){
            var objTextStream  = objFSO.OpenTextFile(logname, 2, true);
            objTextStream.WriteLine("log started");
            objTextStream.Close();
            objTextStream = null;
        }
            
        
        var objTextStream = objFSO.OpenTextFile(logname, fsoForAppend);
        objTextStream.WriteLine (new Date().getVarDate());
        objTextStream.WriteLine (message);
        objTextStream.Close();
        var objTextStream = null;
        var objFSO = null;
    }
}



%>