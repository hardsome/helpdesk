

//earlier in the code:
//disable the cross domain restrictions for JQuery:  $.support.cors = true;
//disable cross domain restriction in the browser. cordova does it with cmd: cordova run browser.


function ViewProxy(callback, controller, action) {
    var Callback = callback;
    if (typeof Callback!='function')
        return false;
    var Controller = String(controller);
    var Action = String(action);
    var View = null;


    //module CacheViewStorage
    var CacheViewStorage = (function() {
        //Private vars/methods
        var enabled = true;
        var minViewLength = 2;
        var storagename = appName + "/Views/" + Controller + "/" + Action;
        var read = function() {
            if (!enabled) return false;
            if (typeof (Storage) !== "undefined") {
                // Yes! localStorage and sessionStorage support!
                View = localStorage[storagename];
                if (View) {
                    if (View.length > 1) {
                        Callback(null, View);
                        return true;
                    }
                }
                View = null;
                return false; //read was not successful
            }
            else {
                // Sorry! No web storage support..
                return false;
            }
        };
        var write = function() {
            if (!View) return false;
            if (View.length < minViewLength) return false;

            //if (!enabled) return false;  //write anyway
            if (typeof (Storage) !== "undefined") {
                // Yes! localStorage and sessionStorage support!
                localStorage[storagename] = View;
                return true;
            }
            else {
                // Sorry! No web storage support..
                return false;
            }
        };
        var clear = function() {
            if (!enabled) return false;
            if (typeof (Storage) !== "undefined") {
                // Yes! localStorage and sessionStorage support!
                //localStorage.clear();
                //clear removes all cache values for domain. for subdomains remove values via iteration.
                for (var key in localStorage) {
                    if (key.substring(0, appName.length) === appName)
                        localStorage.removeItem(key);
                }
                return true;
            }
            else {
                // Sorry! No web storage support..
                return false;
            }
        };
        //Public vars/methods 
        return {
            read: read,
            write: write,
            clear: clear
        }
    })(); //end of CacheViewStorage module

    /*
    we get views over ajax calls.
    what things are important:
     - cross domain enabled
     - syncronous calls
    */

    //module FileSystemViewStorage
    var FsViewStorage = (function() {
        //Private vars/methods
        var read = function() {
            //Load the view from local folder
            View = jQuery.ajax({
                type: "GET",
                url: "Client/Views/" + Controller + "/" + Action + ".html",
                crossDomain: true,
                cache: false,
                async: false
            }).responseText;
            if (View) {
                if (View.length > 1) {
                    Callback(null, View);
                    return true;
                }
            }
            View = null;
            return false;
        };
        //Public vars/methods 
        return {
            read: read
        }
    })();    //end of FsViewStorage module

    //module AjaxViewStorage
    //uses global baseurl - an application in the internet.
    var AjaxViewStorage = (function() {
        //Private vars/methods
        var read = function() {
            //Load the view from local folder
            View = jQuery.ajax({
                type: "GET",
                url: baseurl + "Views/" + Controller + "/" + Action + ".html",
                crossDomain: true,
                cache: false,
                async: false
            }).responseText;
            if (View) {
                if (View.length > 1) {
                    Callback(null, View);
                    return true;
                }
            }
            return false;
        };
        //Public vars/methods 
        return {
            read: read
        }
    })(); //end of AjaxViewStorage

    if ((controller == "ViewCache") && (action = "clear")) {
        CacheViewStorage.clear();
        return;
    }

    //main logic
    if (CacheViewStorage.read()) {
        return true;
    }
    else{
        if (FsViewStorage.read()) {
            CacheViewStorage.write();
            return true;
        }
        else{
            if (AjaxViewStorage.read()) {
                CacheViewStorage.write();
                return true;
            }
            else {
                Callback(null, null);
            }    
        }
    }
};


