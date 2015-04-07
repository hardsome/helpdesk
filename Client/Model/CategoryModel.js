

    //protocol: CRUDL+
    // This file defines the Category model
    // Generator produces  a dumb proxy to DB layer,
    // but in a real application it will be extended.

    // Model is an additional layer if any sophisticated logic should be added to an application.
    // a Client side Controller should talk to remote servers, filesystems and localstorage. 
    // a Client side Controller should work with view and interface. It can't provide any more of logic. 
    // so move more data-related complex logic to Client side Model.
    //
    // This file defines the Category model
    //
    
    
    if (!(DataModel))
        var DataModel = {};
    DataModel.Category = function(objOrID, CategoryName,SortOrder ){
        this.id = null;
        
        this.CategoryName = null; 
        this.SortOrder = null; 
        
        if (objOrID==null)
          return;
        if (validator.isInt(objOrID)){
            this.id = new Number(objOrID);
            if (typeof(CategoryName)!='undefined')
                this.CategoryName = validator.toString(CategoryName);
                if (typeof(SortOrder)!='undefined')
                this.SortOrder = validator.toInt(SortOrder);
                
        }
        else{
            var args = objOrID;
            if (validator.isInt(args.id))
                this.id = validator.toInt(args.id);
                if (typeof(args['CategoryName'])!='undefined')
                  this.CategoryName =   validator.toString(args["CategoryName"]);
                if (typeof(args['SortOrder'])!='undefined')
                  this.SortOrder = validator.toInt(args["SortOrder"]);
                
        }
   }//end Category


    //'======================
    CategoryHelper = (function(){
      //Private members
      var location = 'remoteserver'; //'localstorage', 'remoteserver' or 'filesystem'
      var collection = 'Category';
      
      //Public members
      return{

          //Create a new Category and save in in the DB.
          //call back with result - object or null
          Create : function (obj,cb){
              //preserve the variables to use in async call back
              var args = obj;
              var operation = "Create";
              var myCallBack = cb;
              
              function asyncCB(objResult) {
                 if (typeof myCallBack=="function")
                      myCallBack(objResult);
              }
              
              //async DB insert
              DB.Execute(location, collection, operation, obj, asyncCB);
          },

          // Select the Category from DB by ID
          // call back with result - object or null
          Read : function (obj,cb){
              var args = obj;
              var operation = "Read";
              var myCallBack = cb;
              
              function asyncCB(objResult) {
                  if (typeof myCallBack=="function")
                      myCallBack(objResult);
              }
              
              //async DB Delete
              DB.Execute(location, collection, operation, obj, asyncCB);
          },

          //Updates the existing Category in the DB.
          //call back with result - object or null
          Update : function (obj,cb){
              var args = obj;
              var operation = "Update";
              var myCallBack = cb;
              
              function asyncCB(objResult) {
                  if (typeof myCallBack=="function")
                      myCallBack(objResult);
              }
              
              //async DB Update
              DB.Execute(location, collection, operation, obj, asyncCB);
          },

          //Deletes the Category from the DB.
          //call back with result - object or null
          Delete : function (obj,cb){
              var args = obj;
              var operation = "Delete";
              var myCallBack = cb;
              
              function asyncCB(objResult) {
                  if (typeof myCallBack=="function")
                      myCallBack(objResult);
              }
              
              //async DB Delete
              DB.Execute(location, collection, operation, obj, asyncCB);
          },


          // Select all Categorys into a Array
          // return a Array of Category objects - if successful, null otherwise
          List : function (obj,cb){
              var args = obj;
              var operation = "List";
              var myCallBack = cb;
              
              function asyncCB(objResult) {
                  if (typeof myCallBack=="function")
                      myCallBack(objResult);
              }
              DB.Execute(location, collection, operation,  obj, asyncCB);
          },

          // Select all Categorys into a Array
          // return a Array of Category objects - if successful, null otherwise
          //arguments: obj:{fName:'field name to apply',fValue:'field value to apply'}, cb = function(retModel)
          SelectByField : function (obj,cb){
              var args = obj;
              var operation = "List";
              var myCallBack = cb;
              
              function asyncCB(objResult) {
                  if (Array.isArray(objResult.data.items))
                      objResult =  objResult.data.items.filter(function (item) { return item[obj.fName] === obj.fValue; });
                  if (typeof myCallBack=="function")
                      myCallBack(objResult);
              }
                DB.Execute(location, collection, operation,  obj, asyncCB);
          },

          // Select all Category objectss into a Array
          // return a Array of Category objects - if successful, null otherwise
          //arguments :obj:{page:1,nrecords:40,order:'field name'}, cb = function(retModel)
          SelectPage : function (obj,cb){
              var args = obj;
              var operation = "List";
              var myCallBack = cb;
              var rStart =  ((obj.page-1)*obj.nrecords);
              var rEnd = obj.page*obj.nrecords;

              function sortByKey(array, key) {
                  return array.sort(function(a, b) {
                      var x = a[key]; var y = b[key];
                      return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                  });
              }

              function asyncCB(objResult) {
                  if (Array.isArray(objResult.data.items)){
                      objResult.data.items = sortByKey(objResult.data.items,obj.order);
                      //got the data, define the real start and end
//TODO fix the range       
                      var itemsLen = objResult.data.items.length;
                      rEnd = (itemsLen>rEnd) ? itemsLen : rEnd;
                      rStart = (rStart>0) ? rStart : 0;
                      rStart = (rStart>itemsLen) ? itemsLen : rStart;
                      objResult =  objResult.data.items.slice(rStart,rEnd);
                  }
                  if (typeof myCallBack=="function")
                      myCallBack(objResult);
              }
               DB.Execute(location, collection, operation, obj, asyncCB);

          },
        
          // Select all Category objects into a Array
          // return a Array of Category objects - if successful, null otherwise
          //parameter obj : function (item) { return item.field.search('being searched')>0; }, cb - a call back function
          Search : function (obj,cb){
              var args = obj;
              var operation = "List";
              var myCallBack = cb;
              
              function asyncCB(objResult) {
                  if (Array.isArray(objResult.data.items))
                      objResult.data.items =  objResult.data.items.filter(obj);
                  if (typeof myCallBack=="function")
                      myCallBack(objResult);
              }
 
              DB.Execute(location, collection, operation, obj, asyncCB);
          },

          // Count Category objects
          // return Counter - if successful, null otherwise
          Count : function(obj,cb){
              var args = obj;
              var operation = "List";
              var myCallBack = cb;
              
              function asyncCB(objResult) {
                  if (Array.isArray(objResult.data.items))
                      if (typeof myCallBack=="function")
                          myCallBack(objResult.data.items.length);
              }
                DB.Execute(location, collection, operation, obj, asyncCB);
          },
          
          // Select all Categorys into a Array
          // return a Array of Category objects - if successful, null otherwise
          DropDown : function (obj, cb){
              var args = obj;
              var operation = "List";
              var myCallBack = cb;

              function sortByKey(array, key) {
                  return array.sort(function(a, b) {
                      var x = a[key]; var y = b[key];
                      return ((x < y) ? -1 : ((x > y) ? 1 : 0));
                  });
              }

              function asyncCB(objResult) {
                  if (Array.isArray(objResult.data.items)){
                      objResult.data.items = sortByKey(objResult.data.items,'id');
                      var returnValue = new Array();
                      for (var i=0; i<objResult.data.items.length;i++){
//change the  "CategoryName" to whatever you want to see in the dropdown
                          var objRow = {id :objResult.data.items[i].id ,  name: objResult.data.items[i]["CategoryName"] };
                          returnValue.push (objRow);
                      }
                      if (typeof myCallBack=="function")
                          myCallBack({data : returnValue});
                          return;
                  }
                  if (typeof myCallBack=="function")
                      myCallBack(null);
                      return;
              }
              DB.Execute(location, collection, operation, obj, asyncCB);
          }

      }//end public members
    })(); //end CategoryHelper
  