
<%
      //CRUDL+ operations
      /* Client-side controller expects something like this
         {data:{items : [list of objects]}, result: true/false, paginator : object, message: "message text" };
      */
      var PriorityController = (function() {
         //Private vars/methods
      
         var Create = function(callback){
            var args = safeRequest.Form;
            var obj = new Priority();
            obj.PriorityName = validator.toString(args["PriorityName"]);
            obj.CSSClass = validator.toString(args["CSSClass"]);
            obj.SortOrder = validator.toInt(args["SortOrder"]);
            
            var result = PriorityHelper.Insert(obj);
            var model = {result : result, data: obj };

            callback(JSON.stringify(model),"application/json") ;
         };

         //basic update operation - get the model from DB
         var Read = function (callback,vars){
            var model = {result: false};
            if (vars){
                var id = vars.split('/')[0];
                if (validator.isInt(id)&&(id>0)) {
                   model = {data: PriorityHelper.SelectById(String(id))};
                }
                else
                   model = {data : new Priority()};
            }
            callback(JSON.stringify(model),"application/json") ;
         };

         //basic update operation - put the model back to DB
         var Update = function (callback){
            var model = {result: false};
            var args = safeRequest.Form;
            var id = args["id"];
            if (isInt(Number(id))){
                var obj;
                obj = PriorityHelper.SelectById(id);
                obj.PriorityName = validator.toString(args["PriorityName"]);
                obj.CSSClass = validator.toString(args["CSSClass"]);
                obj.SortOrder = validator.toInt(args["SortOrder"]);
                
                var result =  PriorityHelper.Update(obj);
                model = {result : result, data : obj };
            }
            callback(JSON.stringify(model),"application/json") ;
         };

         //basic delete operation - delete the object from DB
         var Delete = function(callback){
            var model = {result: false};
            var args = safeRequest.Form;
            var id = args["id"];
            if (validator.isInt(Number(id))){
                model = {result :  PriorityHelper.Delete(id) ,data : {id : id} };
            }
            callback(JSON.stringify(model),"application/json") ;
         };

         var PagedList = function(callback,vars){
              var q = '';
              if (vars) q = String(vars.split('/')[0]);

              var current = ((q.length < 10)&&(String(Number(q))==q)) ? Number(q) : 1;
              var searchstring = ((q.length > 4)&&(q.length < 6)&&(String(Number(q))!=q)) ? q : '';

              var model = {result: false};
              if (searchstring!=''){
                model = {data : {items : PriorityHelper.Search(searchstring) }};
                callback(JSON.stringify(model),"application/json") ;
                return;
              }

              var paginator = {
                current   : current,
                first     : 1,
                perpage   : 15,
                total     :PriorityHelper.Count()
                };
              if 	(paginator.total<paginator.perpage*3){
                paginator = null; //not needed
                model = {data : {items:PriorityHelper.SelectAll()} };
              }
              else{
                 //paginator is not optional
                 //fix   
                if (paginator.current<1) paginator.current = 1;
                 //calculate
                paginator.last    = Math.floor( paginator.total / paginator.perpage)+1;
                paginator.startpos = Math.floor(paginator.current / 10)*10;
                paginator.previous = paginator.startpos - 1;
                 //fix
                if (paginator.startpos<1) {
	                paginator.startpos =1;
	                paginator.previous = null;
                }
                 //calculate 
                paginator.endpos = paginator.startpos + 9;
                paginator.next = paginator.endpos + 1;
                 //fix
                if (paginator.endpos>paginator.last) {
	                paginator.endpos=paginator.last;
	                paginator.next = null;
                }
                 //build links
                paginator.links = new Array();
                for (i=paginator.startpos; i<=paginator.endpos;i++){
	                paginator.links.push({n:i,c:i==paginator.current});
                }
                model = {
	                data : { 
                    items: PriorityHelper.SelectPage(paginator.current,paginator.perpage,'id'),
	                  paginator : paginator
                  }
                };
              }
              callback(JSON.stringify(model),"application/json") ;
         };
        
         //basic List operation
         var BasicList = function(callback){
            var model = {data : {items: PriorityHelper.SelectAll()} };
            callback(JSON.stringify(model),"application/json") ;
         };
        
         //read operation, only id and name
         var DropDown = function(callback){
            var model = {data : PriorityHelper.DropDown() };
            callback(JSON.stringify(model),"application/json") ;
         };

       //Public vars/methods 
       return { 
          Create     : Create,
          Read       : Read,
          Update     : Update,
          Delete     : Delete,
          List       : PagedList,
          DropDown   : DropDown 
       } 
       
      })(); 

      //list of allowed controller/action
      controllers['Priority']=PriorityController;

%>
    