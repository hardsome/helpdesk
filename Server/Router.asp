
<%@  language="javascript" %>
<%

//allowed controllers and actions
var controllers = {};
var baseurl = "http://localhost/helpdesk/";

%>

<!--#include file="controllers/controllers.asp" -->
<!--#include file="utils/utils.asp" -->
<!--#include file="models/models.asp" -->

<%
//here should be some protection, e.g. check the lenght of request or IP blocking
//here could be some authentication/authorization, e.g. cookie, session, etc.

var safeRequest = SanitizeRequest();
route();

function route() {
    var defaultController = "Home"
    var defaultAction = "Index"
    var controller = null;
    var action = null;
    var vars = null;

    //the path should be like this:  /ApplicationPath1/../ApplicationPathN/Controller/Action/var1/var2/var3
    //fix for ports,
    var url = validator.escape(location.href.replace(':80/','/').replace(':443/','/'));
    //substract application path from url and remove hash
    var regex = new RegExp(baseurl, "ig") 
    var globalpath = url.replace(regex, '').split(/\?|\#/); 
    //var globalpath = location.href.replace(baseurl, '').split('#'); 
    var path = globalpath[0];
    //normalyze path
    if (path.charAt(0) != "/") path = "/" + path;
    
    
    var pathchuncks = path.split('/');
    if (pathchuncks.length) {
        if (pathchuncks.length >= 3) {
            controller = pathchuncks[1]; //suffix 'Controller' is not used on client
            action = pathchuncks[2];
        };
        if (pathchuncks.length > 3) {
            vars = pathchuncks.slice(3).join('/');
        };
    };

    if (!controller) {
        controller = defaultController;
    };
    if (!action) {
        action = defaultAction;
    };

    //alert(controller);
    //alert(action);
    
    //* an alternative method to CALL Controller.Action with callback:*/
    var Callback = function(content,contenttype){
		//if HTML is expected, send it
		//Response.ContentType="application/json"; 
		//Response.ContentType="text/html"; 
		//Response.ContentType="text/plain"; 
		Response.ContentType = contenttype;
		if (contenttype.toLowerCase()=="application/json"){
        //Response.ExpiresAbsolute = new Date(2000,1,1);
			  Response.AddHeader ("pragma", "no-cache");
			  Response.AddHeader ("cache-control", "private, no-cache, must-revalidate" );
        Response.CodePage = 65001;
			  Response.CharSet = "utf-8";
    }
		//draw the content
		Response.write(content);
		Response.end();
	};

    if (controllers[controller]){
		if (controllers[controller][action]){
			var ControllerAction = controllers[controller][action];
			ControllerAction(Callback,vars);
			return;
		}
	}
    /* //end of alternative method block */
    //when here, no controller/action found, may report 404, for now just close response
    Response.Clear();
    Response.Status="404 Not Found";
    Response.End();

};



%>
    