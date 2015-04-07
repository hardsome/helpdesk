Exception = function(errorMessage) {
    Response.Clear();
    Response.Status = "500 Internal Server Error";
    Response.Write(errorMessage);
    Response.End();
}

if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(elt /*, from*/) {
        var len = this.length >>> 0;

        var from = Number(arguments[1]) || 0;
        from = (from < 0)
         ? Math.ceil(from)
         : Math.floor(from);
        if (from < 0)
            from += len;

        for (; from < len; from++) {
            if (from in this &&
          this[from] === elt)
                return from;
        }
        return -1;
    };
}

//taket from https://developer.mozilla.org/en-US/docs/JXON#Reverse_Algorithms
function createXML (oObjTree) {
  function loadObjTree (oParentEl, oParentObj) {
    var vValue, oChild;
    if (oParentObj instanceof String || oParentObj instanceof Number || oParentObj instanceof Boolean) {
      oParentEl.appendChild(oNewDoc.createTextNode(oParentObj.toString())); /* verbosity level is 0 */
    } else if (oParentObj.constructor === Date) {
      oParentEl.appendChild(oNewDoc.createTextNode(oParentObj.toGMTString()));    
    }
    for (var sName in oParentObj) {
      if (isFinite(sName)) { continue; } /* verbosity level is 0 */
      vValue = oParentObj[sName];
      if (sName === "keyValue") {
        if (vValue !== null && vValue !== true) { oParentEl.appendChild(oNewDoc.createTextNode(vValue.constructor === Date ? vValue.toGMTString() : String(vValue))); }
      } else if (sName === "keyAttributes") { /* verbosity level is 3 */
        for (var sAttrib in vValue) { oParentEl.setAttribute(sAttrib, vValue[sAttrib]); }
      } else if (sName.charAt(0) === "@") {
        oParentEl.setAttribute(sName.slice(1), vValue);
      } else if (vValue.constructor === Array) {
        for (var nItem = 0; nItem < vValue.length; nItem++) {
          oChild = oNewDoc.createElement(sName);
          loadObjTree(oChild, vValue[nItem]);
          oParentEl.appendChild(oChild);
        }
      } else {
        oChild = oNewDoc.createElement(sName);
        if (vValue instanceof Object) {
          loadObjTree(oChild, vValue);
        } else if (vValue !== null && vValue !== true) {
          oChild.appendChild(oNewDoc.createTextNode(vValue.toString()));
        }
        oParentEl.appendChild(oChild);
      }
    }
  }
  const oNewDoc = document.implementation.createDocument("", "", null);
  loadObjTree(oNewDoc, oObjTree);
  return oNewDoc;
}