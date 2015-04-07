
      <%

    //
    // This file defines the Post model
    //
    Post = function(id, PostName,IncidentID,FromUser,ToUser,PostedDate,Desctiption ){
        this.id = new Number(id);
        
        if (typeof(PostName)=='undefined'){
            this.PostName = null;
        }
        else{
            this.PostName = String(PostName);
        }
        if (typeof(IncidentID)=='undefined'){
            this.IncidentID = null;
        }
        else{
            this.IncidentID = String(IncidentID);
        }
        if (typeof(FromUser)=='undefined'){
            this.FromUser = null;
        }
        else{
            this.FromUser = String(FromUser);
        }
        if (typeof(ToUser)=='undefined'){
            this.ToUser = null;
        }
        else{
            this.ToUser = String(ToUser);
        }
        if (typeof(PostedDate)=='undefined'){
            this.PostedDate = null;
        }
        else{
            this.PostedDate = String(PostedDate);
        }
        if (typeof(Desctiption)=='undefined'){
            this.Desctiption = null;
        }
        else{
            this.Desctiption = String(Desctiption);
        }
        
     }
   //end Post


    //'======================
    PostHelper = (function(){
      
        //Private members
        var selectSQL = " SELECT * FROM [Post] ";
        var PopulateObjectFromRecord = function (record){
            if (record.eof){
              return null;
            }
            else{
              var obj;
              obj = new Post()
              obj.id = record("id").Value;
              obj.PostName = record("PostName").Value;
              obj.IncidentID = record("IncidentID").Value;
              obj.FromUser = record("FromUser").Value;
              obj.ToUser = record("ToUser").Value;
              obj.PostedDate = new Date(record("PostedDate").Value).toISOString();
              obj.Desctiption = record("Desctiption").Value;
              
              return obj;
            }
        }

      //Public members
      return{

          //Create a new Post.
          //true - if successful, false otherwise
          Insert : function (obj){
              var strSQL , objCommand, execResult;
              strSQL=   " Insert into [Post] (   [PostName] ,  [IncidentID] ,  [FromUser] ,  [ToUser] ,  [PostedDate] ,  [Desctiption] )" +
              " Values (  ?,  ?,  ?,  ?,  ?,  ?); " +
              " SELECT SCOPE_IDENTITY()  " ;
              
              objCommand = Db.GetCommand(strSQL, new Array(   obj.PostName,  obj.IncidentID,  obj.FromUser,  obj.ToUser,  obj.PostedDate,  obj.Desctiption ) );
              if (objCommand==null){
                  return false;
              }
              else{
                  execResult = objCommand.Execute();
                  execResult = execResult.NextRecordSet();// ' ---- Fix for having a second command in the SQL batch
                  obj.id = new Number(execResult(0));
                  execResult = null; objCommand = null;
                  return true;
              }
          },

          // Update the Post
          Update : function (obj){
              var strSQL, objCommand;
              strSQL= "Update [Post] set   [PostName]=? ,  [IncidentID]=? ,  [FromUser]=? ,  [ToUser]=? ,  [PostedDate]=? ,  [Desctiption]=?   Where id = ? " ;
              objCommand = Db.GetCommand(strSQL, new Array(  obj.PostName,   obj.IncidentID,   obj.FromUser,   obj.ToUser,   obj.PostedDate,   obj.Desctiption,    obj.id));

              if (objCommand!=null){
                  objCommand.Execute();
                  objCommand = null;
                  return true;
              }
              else{
                  return false;
              }
          },

          // Delete the Post
          Delete : function (id){
              var strSQL, objCommand;
              strSQL= "DELETE FROM [Post] WHERE id = ?";
              objCommand = Db.GetCommand(strSQL, new Array(id));
              
              if (objCommand!=null){
                  objCommand.Execute();
                  objCommand = null;
                  return true;
              }
              else{
                  return false;
              }
          },

          // Select the Post by ID
          // return Post object - if successful, null otherwise
          SelectById : function(id){
              var strSQL, objCommand, record, returnValue;
              strSQL = selectSQL + " Where id = ? ";
              objCommand = Db.GetCommand(strSQL, new Array(id));
              if (objCommand!=null){
                  record = objCommand.Execute();
                  returnValue = PopulateObjectFromRecord(record);
                  record.Close(); record = null;
                  return returnValue;
              }
              else{
                  return null;
              }
          },

          // Select all Posts into a Array
          // return a Array of Post objects - if successful, null otherwise
          SelectAll : function (){
              var records, objCommand
              objCommand = Db.GetCommand(selectSQL);
              records = objCommand.Execute();
              if (records.eof){
                  records = null; objCommand = null;
                  return null;
              }
              else{
                  var returnValue, obj, record;
                  returnValue = new Array();
                  while (!records.eof){
                      obj = PopulateObjectFromRecord(records);
                      returnValue.push (obj);
                      records.movenext();
                  }
                  records.Close(); records = null; objCommand = null;
                  return returnValue;
              }
          },

          // Select all Posts into a Array
          // return a Array of Post objects - if successful, null otherwise
          DropDown : function (){
              var records, objCommand
              objCommand = Db.GetCommand(selectSQL);
              records = objCommand.Execute();
              if (records.eof){
                  records = null; objCommand = null;
                  return null;
              }
              else{
                  var returnValue, obj, record;
                  returnValue = new Array();
                  while (!records.eof){
                      obj = {id : records("id").Value ,  name: records("PostName").Value };
                      returnValue.push (obj);
                      records.movenext();
                  }
                  records.Close(); records = null; objCommand = null;
                  return returnValue;
              }
          },

          // Select all Posts into a Array
          // return a Array of Post objects - if successful, null otherwise
          SelectByField : function (fieldName, value){
              var strSQL, records,objCommand;
              strSQL =  selectSQL + " where " + fieldName + "=?";
              objCommand = Db.GetCommand(strSQL, new Array(value));
              if (objCommand!=null){
                  records = objCommand.Execute();
                  if (records.eof){
                      records = null; objCommand = null;
                      return null;
                  }
                  else{
                      var returnValue, obj, record;
                      returnValue = new Array();
                      while (!records.eof){
                          obj = PopulateObjectFromRecord(records);
                          returnValue.push (obj);
                          records.movenext();
                      }
                      records.Close(); records = null; objCommand = null;
                      return returnValue;
                  }
              }
              else{
                return null;
              }
          },

          // Select all Posts into a Array
          // return a Array of Post objects - if successful, null otherwise
          SelectPage : function (page, nrecords, order){
              var records, objCommand, strSQL
              var rStart = new String( 1+ ((page-1)*nrecords));
              var rEnd = new String (page*nrecords);

              strSQL = "WITH CTE AS (select *, row_number() over(order by " + order + ") as rn from [Post] )" +
              "SELECT * FROM CTE WHERE rn Between " + rStart + " and " + rEnd

              objCommand = Db.GetCommand(strSQL);
              records = objCommand.Execute();
              if (records.eof){
                  records = null; objCommand = null;
                  return null;
              }
              else{
                  var returnValue, obj, record;
                  returnValue = new Array();
                  while (!records.eof){
                      obj = PopulateObjectFromRecord(records);
                      returnValue.push (obj);
                      records.movenext();
                  }
                  records.Close(); records = null; objCommand = null;
                  return returnValue;
              }
          },
        
          // Select all Posts into a Array
          // return a Array of Project objects - if successful, null otherwise
          Search : function (value){
              var records, objCommand, strSQL;
              //(1=2) is a fake condition needed here because of codegenerator, may remove it in production code
              strSQL = selectSQL + " where (1=2) "  + " or (PostName like '%" + value + "%') "         + " or (  Desctiption like '%" + value + "%') "        ;
              objCommand = Db.GetCommand(strSQL);
              
              records = objCommand.Execute();
              if (records.eof){
                  records = null; objCommand = null;
                  return null;
              }
              else{
                  var returnValue, obj, record;
                  returnValue = new Array();
                  while (!records.eof){
                      obj = PopulateObjectFromRecord(records);
                      returnValue.push (obj);
                      records.movenext();
                  }
                  records.Close(); records = null; objCommand = null;
                  return returnValue;
              }
          },

          // Count Posts
          // return Counter - if successful, null otherwise
          Count : function(){
              var strSQL, record, objCommand, returnValue;
              strSQL = "SELECT Count(id) as [Counter] FROM [Post] ";
              objCommand = Db.GetCommand(strSQL);
              record = objCommand.Execute();
              if (record.eof){
                  records = null; objCommand = null;
                  return null;
              }
              else{
                  var retValue = record("Counter").Value;
                  record = null; objCommand = null;
                  return retValue;
              }
          }
      }//end public members
    })(); //end PostHelper
    %>
  