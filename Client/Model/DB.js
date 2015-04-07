
//TODO: rewrite to use 2-level cache - in-memory+localStorage
//earlier in the code:
//disable the cross domain restrictions for JQuery:  $.support.cors = true;
//disable cross domain restriction in the browser. cordova does it with cmd: cordova run browser.
/*
protocol: CRUDL +
*/




//this is a dispatcher
//call it as:
//DB.Execute(location, collection, operation, arg, callback);
var DB = (function () {
	//Private members
	//db instance storage;
	var storageCollection = [];
	var outModel = null;
	

	var AddDbInstance = function (location, instance) {
		storageCollection.push({ DbInstanceName: location, DbInstanceRef: instance });
	}

	var Execute = function (location, collection, operation, arg, callback) {
		//check if storage is supported
		var DbInstance = storageCollection.filter(function (item) { return item.DbInstanceName == location; })[0]
		if (typeof DbInstance != 'undefined') {
			if (typeof DbInstance.DbInstanceRef.Execute == 'function') {
				DbInstance.DbInstanceRef.Execute(collection, operation, arg, callback);
				return;
			}
		}
		if (typeof callBack == "function")
			callback(null);
		return;
	}

	//Public members
	return {
		AddDbInstance: AddDbInstance,
		Execute: Execute,
		minOutModelLength : 2
	}//end public members
})(); //end DB



//module localstorage
//CRUDL inside - mapped to
//the oprations supported when talk to remote server controller : 
//List, Read,Create,CreatePost, Update,UpdatePost, Delete,DeletePost, DropDown
DB.AddDbInstance(
	'localstorage',
	(function () {
		//Private vars/methods
		var enabled = true;

		//get data from localStorage
		var ReadModel = function (collection,lsAddress) {
			if (typeof lsAddress == 'undefined')
				lsAddress = appName + "." + collection;
			if (!enabled) return null;
			if (typeof (Storage) == "undefined") {
				return null;
			}
			else {
				var localModel = localStorage.getItem(lsAddress);
				if (localModel) {
					if (localModel.length >= DB.minOutModelLength) {
						return JSON.parse(localModel);
					}
				}
				else {
					//return a standard List model. this model is expected by other CRUD functions and List templates
					return { "data": { "items": [] } };
				}
			}
			return null; //was not successful
		};

		//set data to localStorage
		var WriteModel = function (localModel,collection,lsAddress) {
			if (typeof lsAddress == 'undefined')
				lsAddress = appName + "." + collection ;
			if (!enabled) return null;
			if (typeof (Storage) == "undefined") {
				return null;
			}
			else {
				localStorage.setItem(lsAddress, localModel);
				return true;
			}
			return null; //was not successful
		};

		var Read = function (collection, operation, arg, callback) {
			var localModel = ReadModel(collection);
			if (localModel == null) return false;
			//sanitize
			if (String(Number(arg)) != arg) return false;
			var id = Number(arg);
			var obj = localModel.data.items.filter(
				function (obj) {
					return obj.id === id;
				})[0];
			if (typeof (obj) != 'undefined') {
				callback({ data: obj });
				return true;
			}
			//on fail
			return false;
		};

		var Update = function (collection, operation, arg, callback) {
			var localModel = ReadModel(collection);
			if (localModel == null) {
				return false;
			}
			else {
				//the next is a synonym of: var obj = new DataModel.Class(arg); 
				var obj = new DataModel[collection](arg);
				var existingObj = localModel.data.items.filter(function (item) { return item.id === obj.id; })[0];
				if (typeof (existingObj) != 'undefined') {
					//found one, update
					localModel.data.items[localModel.data.items.indexOf(existingObj)] = obj;
					WriteModel(JSON.stringify(localModel),collection);
					callback({ result: true, data: obj });
					return true;
				}
				//insert new as not found existing
				//fix auto-id for new object
				if (!(validator.isInt(obj.id))) {
					var maxID = Math.max.apply(Math, localModel.data.items.map(function (item) { return item.id; })) + 1;
					if (!(validator.isInt(maxID))) maxID = 1;
					obj.id = maxID;
				}
				//push obj to Model and save
				localModel.data.items.push(obj);
				WriteModel(JSON.stringify(localModel),collection);
				callback({ result: true, data: obj });
				return true;
			}
		};
		var Delete = function (collection, operation, arg, callback) {
			var localModel = ReadModel(collection);
			if (localModel == null) {
				return false;
			}
			else {
				//the next is a synonym of: var obj = new DataModel.Class(arg);
				var obj = new DataModel[collection](arg);
				if (!(validator.isInt(obj.id))) {
					return false;
				}
				var existingObj = localModel.data.items.filter(function (item) { return item.id === obj.id; })[0];
				if (typeof (existingObj) != 'undefined') {
					localModel.data.items.splice([localModel.data.items.indexOf(existingObj)], 1);
					WriteModel(JSON.stringify(localModel),collection);
					callback({ result: true, data: obj });
					return true;
				}
				return false;
			}
		};
		var List = function (collection, operation, arg, callback) {
			var localModel = ReadModel(collection);
			if (localModel == null) localModel = {};
			callback(localModel);
			return true;
		};
		var DropDown = function (collection, operation, arg, callback) {
			var localModel = ReadModel(collection);
			if (localModel == null) return false;

			var retvalue = { data: new Array() };
			retvalue.data = localModel.data.items.map(function (item) { return { id: item.id, name: item[collection + "Name"] }; });
			callback(retvalue);
			return true;
		};

		var ExecuteOperation = function (collection, operation, arg, callback) {
			//CRUD operations + operations by name
			switch (operation) {
				case "Create":
				case "Update":
					Update(collection, operation, arg, callback);
					return;
				case "Read":
				    if (validator.isInt(arg))
						return Read(collection, operation, arg, callback);
					else {
//TODO :modify DataModel[collection]
// it is not in the DataModel name space anymore
debugger;						
/*						if (typeof DataModel[collection] != 'undefined') {
							var obj = new DataModel[collection]();
							callback({ "data": obj });
							return true;
						}
						else
*/
						 callback(null);
					}
					return;
				case "Delete":
					Delete(collection, operation, arg, callback);
					return;
				case "List":
					List(collection, operation, arg, callback);
					return;
				case "DropDown":
					DropDown(collection, operation, arg, callback);
					return;
				default:
					var localModel = ReadModel(appName + "/" + collection + "/" + operation);
					callback(localModel);
					return;
			}
		};

		//Public vars/methods 
		return {
			Execute: ExecuteOperation
			//
		}
	})() //end of 'localstorage' module
);

/*
we get data over ajax calls.
things are important:
- cross domain enabled
- syncronous calls
*/

//module FileSystemDataStorage
//filesystem is read only, but can provide a lot of "quasi"-operations
DB.AddDbInstance(
    'filesystem',
	(function () {
		//Private vars/methods

		var ExecuteOperation = function (collection, operation, arg, callback) {
			//there is no way to send GET requests with QueryString values to file system
			//instead of that the arg will be used as "suffix" 
			//add a 'number' suffix to the file name to provide a variety:
			// e.g. Client/Model/Default/[Read.1.txt, Read.2.txt, Read.all.txt etc] 
			var idSuffix = "";
			if (String(Number(arg)) == arg)
				idSuffix = "." + arg;

			//Load the data from local folder
			var localModel = jQuery.ajax({
				type: "GET",
				url: "Client/Model/Default/" + collection + "/" + operation + idSuffix + ".txt",
				crossDomain: true,
				cache: false,
				async: false
			}).responseText;
			if (localModel) {
				if (localModel.length >= DB.minOutModelLength) {
					if (typeof localModel == "string")
						localModel = JSON.parse(localModel);
					callback(localModel);
					return true;
				}
			}
			return false;
		};
		//Public vars/methods 
		return {
			Execute: ExecuteOperation
		}
	})()     //end of 'filesystem' module
);

//module remoteserverDataStorage
//uses global baseurl - an application in the internet.
DB.AddDbInstance(
    'remoteserver',
   (function () {
   	//Private vars/methods
	var method;
   	var ExecuteOperation = function (collection, operation, arg, callback) {

   		var srvrController = collection;
   		var srvrAction = operation;

   		if (!method) method = 'get';
   		method = method.toLowerCase();
   		if (method == 'post') {
   			$.post(baseurl + srvrController + '/' + srvrAction + '/', arg, function (localModel, status) {
   				callback(localModel);
   				return true;
   			});
   		}
   		else if (method == 'get') {
   			//this string is for MVC server-side code
   			$.get(baseurl + srvrController + '/' + srvrAction + '/' + arg, {}, function (localModel, status) {
   				callback(localModel);
   				return true;
   			});
   		}
   		return false;
   	};
	var Execute = function (collection, operation, arg, callback) {
			switch (operation) {
				case "Create":
				case "Update":
				case "Delete":
					method = "post";
					break;
				case "DropDown":
				case "Read":
				case "List":
					method = "get";
					break;
				default:
				    method = "get";
					break;
			}
		ExecuteOperation (collection, operation, arg, callback);
	}
   	//Public vars/methods 
   	return {
   		Execute: Execute
   	}
   })()       //end of remoteserverDataStorage
);















function IsJsonString(str) {
	try {
		JSON.parse(str);
	} catch (e) {
		return false;
	}
	return true;
}
