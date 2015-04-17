
      <%

    //
    // This file defines the Incident model
    //
    Incident = function(id, IncidentName,ProjectID,StatusID,PriorityID,CategoryID,Description,ReportedDate,UpdatedDate,UserID ){
        this.id = new Number(id);
        
        if (typeof(IncidentName)=='undefined'){
            this.IncidentName = null;
        }
        else{
            this.IncidentName = String(IncidentName);
        }
        if (typeof(ProjectID)=='undefined'){
            this.ProjectID = null;
        }
        else{
            this.ProjectID = String(ProjectID);
        }
        if (typeof(StatusID)=='undefined'){
            this.StatusID = null;
        }
        else{
            this.StatusID = String(StatusID);
        }
        if (typeof(PriorityID)=='undefined'){
            this.PriorityID = null;
        }
        else{
            this.PriorityID = String(PriorityID);
        }
        if (typeof(CategoryID)=='undefined'){
            this.CategoryID = null;
        }
        else{
            this.CategoryID = String(CategoryID);
        }
        if (typeof(Description)=='undefined'){
            this.Description = null;
        }
        else{
            this.Description = String(Description);
        }
        if (typeof(ReportedDate)=='undefined'){
            this.ReportedDate = null;
        }
        else{
            this.ReportedDate = String(ReportedDate);
        }
        if (typeof(UpdatedDate)=='undefined'){
            this.UpdatedDate = null;
        }
        else{
            this.UpdatedDate = String(UpdatedDate);
        }
        if (typeof(UserID)=='undefined'){
            this.UserID = null;
        }
        else{
            this.UserID = String(UserID);
        }
        
     }
   //end Incident


    //'======================
    IncidentHelper = (function(){
      
        //Private members
        var selectSQL = " SELECT * FROM [Incident] ";
        var PopulateObjectFromRecord = function (record){
            if (record.eof){
              return null;
            }
            else{
              var obj;
              obj = new Incident()
              obj.id = record("id").Value;
              obj.IncidentName = record("IncidentName").Value;
              obj.ProjectID = record("ProjectID").Value;
              obj.StatusID = record("StatusID").Value;
              obj.PriorityID = record("PriorityID").Value;
              obj.CategoryID = record("CategoryID").Value;
              obj.Description = record("Description").Value;
              obj.ReportedDate = new Date(record("ReportedDate").Value).toISOString();
              obj.UpdatedDate = new Date(record("UpdatedDate").Value).toISOString();
              obj.UserID = record("UserID").Value;
              
              return obj;
            }
        }

      //Public members
      return{

          //Create a new Incident.
          //true - if successful, false otherwise
          Insert : function (obj){
              var strSQL , objCommand, execResult;
              strSQL=   " Insert into [Incident] (   [IncidentName] ,  [ProjectID] ,  [StatusID] ,  [PriorityID] ,  [CategoryID] ,  [Description] ,  [ReportedDate] ,  [UpdatedDate] ,  [UserID] )" +
              " Values (  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?); " +
              " SELECT SCOPE_IDENTITY()  " ;
              
              objCommand = Db.GetCommand(strSQL, new Array(   obj.IncidentName,  obj.ProjectID,  obj.StatusID,  obj.PriorityID,  obj.CategoryID,  obj.Description,  obj.ReportedDate,  obj.UpdatedDate,  obj.UserID ) );
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

          // Update the Incident
          Update : function (obj){
              var strSQL, objCommand;
              strSQL= "Update [Incident] set   [IncidentName]=? ,  [ProjectID]=? ,  [StatusID]=? ,  [PriorityID]=? ,  [CategoryID]=? ,  [Description]=? ,  [ReportedDate]=? ,  [UpdatedDate]=? ,  [UserID]=?   Where id = ? " ;
              objCommand = Db.GetCommand(strSQL, new Array(  obj.IncidentName,   obj.ProjectID,   obj.StatusID,   obj.PriorityID,   obj.CategoryID,   obj.Description,   obj.ReportedDate,   obj.UpdatedDate,   obj.UserID,    obj.id));

              if (objCommand!=null){
                  objCommand.Execute();
                  objCommand = null;
                  return true;
              }
              else{
                  return false;
              }
          },

          // Delete the Incident
          Delete : function (id){
              var strSQL, objCommand;
              strSQL= "DELETE FROM [Incident] WHERE id = ?";
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

          // Select the Incident by ID
          // return Incident object - if successful, null otherwise
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

          // Select all Incidents into an Array
          // return a Array of Incident objects - if successful, null otherwise
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

          // Select all Incidents into an Array
          // return a Array of Incident objects - if successful, null otherwise
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
                      obj = {id : records("id").Value ,  name: records("IncidentName").Value };
                      returnValue.push (obj);
                      records.movenext();
                  }
                  records.Close(); records = null; objCommand = null;
                  return returnValue;
              }
          },

          // Select all Incidents into an Array
          // return a Array of Incident objects - if successful, null otherwise
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

          // Select all Incidents into an Array
          // return a Array of Incident objects - if successful, null otherwise
          SelectPage : function (page, nrecords, order){
              var records, objCommand, strSQL;
              var rStart = new String( 1+ ((page-1)*nrecords));
              var rEnd = new String (page*nrecords);

              strSQL = "WITH CTE AS (select *, row_number() over(order by " + order + ") as rn from [Incident] )" +
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
        
          // Select all Incidents into an Array
          // return a Array of Project objects - if successful, null otherwise
          Search : function (value){
              var records, objCommand, strSQL;
              //(1=2) is a fake condition needed here because of codegenerator, may remove it in production code
              strSQL = selectSQL + " where (1=2) "  + " or (IncidentName like '%" + value + "%') "         + " or (  Description like '%" + value + "%') "        ;
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

          // Count Incidents
          // return Counter - if successful, null otherwise
          Count : function(){
              var strSQL, record, objCommand, returnValue;
              strSQL = "SELECT Count(id) as [Counter] FROM [Incident] ";
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
    })(); //end IncidentHelper
    %>
  