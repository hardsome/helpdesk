
      <%

    //
    // This file defines the Project model
    //
    Project = function(id, ProjectName,POP3Address,isActive ){
        this.id = new Number(id);
        
        if (typeof(ProjectName)=='undefined'){
            this.ProjectName = null;
        }
        else{
            this.ProjectName = String(ProjectName);
        }
        if (typeof(POP3Address)=='undefined'){
            this.POP3Address = null;
        }
        else{
            this.POP3Address = String(POP3Address);
        }
        if (typeof(isActive)=='undefined'){
            this.isActive = null;
        }
        else{
            this.isActive = String(isActive);
        }
        
     }
   //end Project


    //'======================
    ProjectHelper = (function(){
      
        //Private members
        var selectSQL = " SELECT * FROM [Project] ";
        var PopulateObjectFromRecord = function (record){
            if (record.eof){
              return null;
            }
            else{
              var obj;
              obj = new Project()
              obj.id = record("id").Value;
              obj.ProjectName = record("ProjectName").Value;
              obj.POP3Address = record("POP3Address").Value;
              obj.isActive = record("isActive").Value;
              
              return obj;
            }
        }

      //Public members
      return{

          //Create a new Project.
          //true - if successful, false otherwise
          Insert : function (obj){
              var strSQL , objCommand, execResult;
              strSQL=   " Insert into [Project] (   [ProjectName] ,  [POP3Address] ,  [isActive] )" +
              " Values (  ?,  ?,  ?); " +
              " SELECT SCOPE_IDENTITY()  " ;
              
              objCommand = Db.GetCommand(strSQL, new Array(   obj.ProjectName,  obj.POP3Address,  obj.isActive ) );
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

          // Update the Project
          Update : function (obj){
              var strSQL, objCommand;
              strSQL= "Update [Project] set   [ProjectName]=? ,  [POP3Address]=? ,  [isActive]=?   Where id = ? " ;
              objCommand = Db.GetCommand(strSQL, new Array(  obj.ProjectName,   obj.POP3Address,   obj.isActive,    obj.id));

              if (objCommand!=null){
                  objCommand.Execute();
                  objCommand = null;
                  return true;
              }
              else{
                  return false;
              }
          },

          // Delete the Project
          Delete : function (id){
              var strSQL, objCommand;
              strSQL= "DELETE FROM [Project] WHERE id = ?";
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

          // Select the Project by ID
          // return Project object - if successful, null otherwise
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

          // Select all Projects into an Array
          // return a Array of Project objects - if successful, null otherwise
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

          // Select all Projects into an Array
          // return a Array of Project objects - if successful, null otherwise
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
                      obj = {id : records("id").Value ,  name: records("ProjectName").Value };
                      returnValue.push (obj);
                      records.movenext();
                  }
                  records.Close(); records = null; objCommand = null;
                  return returnValue;
              }
          },

          // Select all Projects into an Array
          // return a Array of Project objects - if successful, null otherwise
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

          // Select all Projects into an Array
          // return a Array of Project objects - if successful, null otherwise
          SelectPage : function (page, nrecords, order){
              var records, objCommand, strSQL;
              var rStart = new String( 1+ ((page-1)*nrecords));
              var rEnd = new String (page*nrecords);

              strSQL = "WITH CTE AS (select *, row_number() over(order by " + order + ") as rn from [Project] )" +
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
        
          // Select all Projects into an Array
          // return a Array of Project objects - if successful, null otherwise
          Search : function (value){
              var records, objCommand, strSQL;
              //(1=2) is a fake condition needed here because of codegenerator, may remove it in production code
              strSQL = selectSQL + " where (1=2) "  + " or (ProjectName like '%" + value + "%') "         + " or (POP3Address like '%" + value + "%') "        ;
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

          // Count Projects
          // return Counter - if successful, null otherwise
          Count : function(){
              var strSQL, record, objCommand, returnValue;
              strSQL = "SELECT Count(id) as [Counter] FROM [Project] ";
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
    })(); //end ProjectHelper
    %>
  