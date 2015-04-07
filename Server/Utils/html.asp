<%
var Html = {

	Encode: function (elValue){
	    if (String(elValue).length>0) {
			return Server.HTMLEncode(String(elValue))
		}
		else{
		    return "";
		}
	},

	Label: function (elValue, objfor){
		return "<label for='" + objfor + "'>" + this.Encode(elValue) + "</label>";
	},
	
	Hidden: function ( elId, elValue){
	    return  "<input id='" + elId + "' name='" + elId + "' type='hidden' value='" + this.Encode(elValue) + "' />";
	},

	TextBox: function (elId, elValue){
		return "<input id='" + elId + "' name='" + elId + "' type='text' value='" + this.Encode(elValue) + "' />";
	},
	
	TextArea: function (elId, elValue, cols, rows){
		return "<textarea id='" + elId + "' name='" + elId + "' cols='" + this.Encode(cols) + "' rows='" + this.Encode(rows) + "'>" + this.Encode(elValue) + "</textarea>";
	},

	DropDownList: function (elId, elValue, list , idName, valueName){
		var resStr, lisItem;
		resStr= "<select id='" + elId + "' name='" + elId + "'>" ;
		if (list!=null){
			for(var i = 0; i < list.length; i++){
				var optValue, optText;
				optValue = list[i][idName]; //amazing feature JavaScript to access Object property by name of field as an element of array 
				optText  = list[i][valueName] ;
				if (elValue = optValue) {
					resStr = resStr + "<option selected='selected' value='" + this.Encode(optValue) + "'>" + this.Encode(optText) + "</option>";
				}
				else{
					resStr = resStr + "<option value='" + this.Encode(optValue) + "'>" + this.Encode(optText) + "</option>";
				}
			}
		}
		return resStr + "</select>";
	},
	    
    ActionLink: function (linkText, linkController, linkAction , linkVars,  linkClass){ 
		var strVars = "";
        var strClass = "";
        //'Stop
        if(linkVars){
		    strVars = "/";
    		if (linkVars instanceof Array) {
				for( varPair in linkVars){
					strVars  = strVars + "/" + varPair;
				}
		    }
			else{
				strVars = strVars + linkVars;
			}
		}
		
		if (linkClass){
		    strClass = "class='" + linkClass + "'";
		}
         return '<a href="#{0}/{1}/{2}" {3}>{4}</a>'.format( new Array(this.Encode(linkController),this.Encode(linkAction),strVars, strClass, this.Encode(linkText)));
	},

	CheckBox: function ( elId, elValue){
	    var checked ;
	    if (elValue){
			checked = "CHECKED";
		}
		else{
			checked = "";
		}
		return "<input type='checkbox' id='" + elId + "' name='" + elId + "' " + checked + " />" ;
	},

	RenderControllerAction: function (controller,action,vars){
		var controllerName;
        controllerName = controller + "Controller";
		if (vars instanceof Array) {
                actionCallString = controllerName + "." + action + "(vars)"
        }
        else{
                actionCallString = controllerName + "." + action + "()"
        }
        eval (actionCallString);
	}
}

%>