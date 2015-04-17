
      <%

    //
    // This file defines the Category model
    //
    Category = function(id, CategoryName,SortOrder ){
        this.id = new Number(id);
        
        if (typeof(CategoryName)=='undefined'){
            this.CategoryName = null;
        }
        else{
            this.CategoryName = String(CategoryName);
        }
        if (typeof(SortOrder)=='undefined'){
            this.SortOrder = null;
        }
        else{
            this.SortOrder = String(SortOrder);
        }
        
     }
   //end Category


    //'======================
    CategoryHelper = (function(){
      
        //Private members
        var selectSQL = " SELECT * FROM [Category] ";
        var PopulateObjectFromRecord = function (record){
            if (record.eof){
              return null;
            }
            else{
              var obj;
              obj = new Category()
              obj.id = record("id").Value;
              obj.CategoryName = record("CategoryName").Value;
              obj.SortOrder = record("SortOrder").Value;
              
              return obj;
            }
        }

      //Public members
      return{

          //Create a new Category.
          //true - if successful, false otherwise
          Insert : function (obj){
              var strSQL , objCommand, execResult;
              strSQL=   " Insert into [Category] (   [CategoryName] ,  [SortOrder] )" +
              " Values (  ?,  ?); " +
              " SELECT SCOPE_IDENTITY()  " ;
              
              objCommand = Db.GetCommand(strSQL, new Array(   obj.CategoryName,  obj.SortOrder ) );
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

          // Update the Category
          Update : function (obj){
              var strSQL, objCommand;
              strSQL= "Update [Category] set   [CategoryName]=? ,  [SortOrder]=?   Where id = ? " ;
              objCommand = Db.GetCommand(strSQL, new Array(  obj.CategoryName,   obj.SortOrder,    obj.id));

              if (objCommand!=null){
                  objCommand.Execute();
                  objCommand = null;
                  return true;
              }
              else{
                  return false;
              }
          },

          // Delete the Category
          Delete : function (id){
              var strSQL, objCommand;
              strSQL= "DELETE FROM [Category] WHERE id = ?";
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

          // Select the Category by ID
          // return Category object - if successful, null otherwise
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

          // Select all Categorys into an Array
          // return a Array of Category objects - if successful, null otherwise
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

          // Select all Categorys into an Array
          // return a Array of Category objects - if successful, null otherwise
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
                      obj = {id : records("id").Value ,  name: records("CategoryName").Value };
                      returnValue.push (obj);
                      records.movenext();
                  }
                  records.Close(); records = null; objCommand = null;
                  return returnValue;
              }
          },

          // Select all Categorys into an Array
          // return a Array of Category objects - if successful, null otherwise
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

          // Select all Categorys into an Array
          // return a Array of Category objects - if successful, null otherwise
          SelectPage : function (page, nrecords, order){
              var records, objCommand, strSQL;
              var rStart = new String( 1+ ((page-1)*nrecords));
              var rEnd = new String (page*nrecords);

              strSQL = "WITH CTE AS (select *, row_number() over(order by " + order + ") as rn from [Category] )" +
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
        
          // Select all Categorys into an Array
          // return a Array of Project objects - if successful, null otherwise
          Search : function (value){
              var records, objCommand, strSQL;
              //(1=2) is a fake condition needed here because of codegenerator, may remove it in production code
              strSQL = selectSQL + " where (1=2) "  + " or (CategoryName like '%" + value + "%') "        ;
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

          // Count Categorys
          // return Counter - if successful, null otherwise
          Count : function(){
              var strSQL, record, objCommand, returnValue;
              strSQL = "SELECT Count(id) as [Counter] FROM [Category] ";
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
    })(); //end CategoryHelper
    %>
  