
      <%

    //
    // This file defines the Status model
    //
    Status = function(id, StatusName,SortOrder,CSSClass,isDefault ){
        this.id = new Number(id);
        
        if (typeof(StatusName)=='undefined'){
            this.StatusName = null;
        }
        else{
            this.StatusName = String(StatusName);
        }
        if (typeof(SortOrder)=='undefined'){
            this.SortOrder = null;
        }
        else{
            this.SortOrder = String(SortOrder);
        }
        if (typeof(CSSClass)=='undefined'){
            this.CSSClass = null;
        }
        else{
            this.CSSClass = String(CSSClass);
        }
        if (typeof(isDefault)=='undefined'){
            this.isDefault = null;
        }
        else{
            this.isDefault = String(isDefault);
        }
        
     }
   //end Status


    //'======================
    StatusHelper = (function(){
      
        //Private members
        var selectSQL = " SELECT * FROM [Status] ";
        var PopulateObjectFromRecord = function (record){
            if (record.eof){
              return null;
            }
            else{
              var obj;
              obj = new Status()
              obj.id = record("id").Value;
              obj.StatusName = record("StatusName").Value;
              obj.SortOrder = record("SortOrder").Value;
              obj.CSSClass = record("CSSClass").Value;
              obj.isDefault = record("isDefault").Value;
              
              return obj;
            }
        }

      //Public members
      return{

          //Create a new Status.
          //true - if successful, false otherwise
          Insert : function (obj){
              var strSQL , objCommand, execResult;
              strSQL=   " Insert into [Status] (   [StatusName] ,  [SortOrder] ,  [CSSClass] ,  [isDefault] )" +
              " Values (  ?,  ?,  ?,  ?); " +
              " SELECT SCOPE_IDENTITY()  " ;
              
              objCommand = Db.GetCommand(strSQL, new Array(   obj.StatusName,  obj.SortOrder,  obj.CSSClass,  obj.isDefault ) );
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

          // Update the Status
          Update : function (obj){
              var strSQL, objCommand;
              strSQL= "Update [Status] set   [StatusName]=? ,  [SortOrder]=? ,  [CSSClass]=? ,  [isDefault]=?   Where id = ? " ;
              objCommand = Db.GetCommand(strSQL, new Array(  obj.StatusName,   obj.SortOrder,   obj.CSSClass,   obj.isDefault,    obj.id));

              if (objCommand!=null){
                  objCommand.Execute();
                  objCommand = null;
                  return true;
              }
              else{
                  return false;
              }
          },

          // Delete the Status
          Delete : function (id){
              var strSQL, objCommand;
              strSQL= "DELETE FROM [Status] WHERE id = ?";
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

          // Select the Status by ID
          // return Status object - if successful, null otherwise
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

          // Select all Statuss into an Array
          // return a Array of Status objects - if successful, null otherwise
          SelectAll : function (){
              var records, objCommand;
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

          // Select all Statuss into an Array
          // return a Array of Status objects - if successful, null otherwise
          DropDown : function (){
              var records, objCommand;
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
                      obj = {id : records("id").Value ,  name: records("StatusName").Value };
                      returnValue.push (obj);
                      records.movenext();
                  }
                  records.Close(); records = null; objCommand = null;
                  return returnValue;
              }
          },

          // Select all Statuss into an Array
          // return a Array of Status objects - if successful, null otherwise
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

          // Select all Statuss into an Array
          // return a Array of Status objects - if successful, null otherwise
          SelectPage : function (page, nrecords, order){
              var records, objCommand, strSQL;
              var rStart = new String( 1+ ((page-1)*nrecords));
              var rEnd = new String (page*nrecords);

              strSQL = "WITH CTE AS (select *, row_number() over(order by " + order + ") as rn from [Status] )" +
              "SELECT * FROM CTE WHERE rn Between " + rStart + " and " + rEnd;

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
        
          // Select all Statuss into an Array
          // return a Array of Project objects - if successful, null otherwise
          Search : function (value){
              var records, objCommand, strSQL;
              //(1=2) is a fake condition needed here because of codegenerator, may remove it in production code
              strSQL = selectSQL + " where (1=2) "  + " or (StatusName like '%" + value + "%') "         + " or (CSSClass like '%" + value + "%') "        ;
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

          // Count Statuss
          // return Counter - if successful, null otherwise
          Count : function(){
              var strSQL, record, objCommand, returnValue;
              strSQL = "SELECT Count(id) as [Counter] FROM [Status] ";
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
    })(); //end StatusHelper
    %>
  