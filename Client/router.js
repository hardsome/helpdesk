
$(document).ready(function() {
    // Bind the event.
    $(window).hashchange(function() {
        // Alerts every time the hash changes!
        //alert(location.hash);
        route();
    })
});

//list of controllers and actions
var controllers = {};
var baseurl = "http://localhost/helpdesk/";
var appName = "helpdesk";

function route() {
    var defaultController = ""
    var defaultAction = ""
    var controller = null;
    var action = null;
    var vars = null;

    var globalpath = location.hash.split('#');
    if (globalpath.length < 2) return;
    /*default routing is like host:port/Controller/Action/var1/var2/var3 */
    //the path should be like:  /Controller/Action/var1/var2/var3
    var path = globalpath[1];

    //normalyze path
    if (path.charAt(0) != "/") path = "/" + path;

    var pathchuncks = path.split('/');
    if (pathchuncks.length) {
        if (pathchuncks.length >= 3) {
            controller = pathchuncks[1]; //suffix 'Controller' is not used on client
            action = pathchuncks[2];
        }
        if (pathchuncks.length > 3) {
            vars = pathchuncks.slice(3).join('/');
        }
        else  {vars='';}
        
    };

    if (!controller) {
        controller = defaultController;
    };
    if (!action) {
        action = defaultAction;
    };
    NormalizeHash();
    //alert(controller);
    //alert(action);
    if (controllers[controller]){
		if (controllers[controller][action]){
			var ControllerAction = controllers[controller][action];
			ControllerAction(vars,null);
		}
	}

}

function NormalizeHash() {
	if (window.location.hash.length>0){
		window.location.href = location.href.replace(location.hash, '#');
	}
}
    