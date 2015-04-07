
      <%

    //
    // This file defines the Attachment model
    //
    Attachment = function(id, AttachmentName,Incident,Creator,Content,MimeType ){
        this.id = new Number(id);
        
        if (typeof(AttachmentName)=='undefined'){
            this.AttachmentName = null;
        }
        else{
            this.AttachmentName = String(AttachmentName);
        }
        if (typeof(Incident)=='undefined'){
            this.Incident = null;
        }
        else{
            this.Incident = String(Incident);
        }
        if (typeof(Creator)=='undefined'){
            this.Creator = null;
        }
        else{
            this.Creator = String(Creator);
        }
        if (typeof(Content)=='undefined'){
            this.Content = null;
        }
        else{
            this.Content = String(Content);
        }
        if (typeof(MimeType)=='undefined'){
            this.MimeType = null;
        }
        else{
            this.MimeType = String(MimeType);
        }
        
     }
   //end Attachment


    //'======================
    AttachmentHelper = (function(){
      
        //Private members
        var selectSQL = " SELECT * FROM [Attachment] ";
        var PopulateObjectFromRecord = function (record){
            if (record.eof){
              return null;
            }
            else{
              var obj;
              obj = new Attachment()
              obj.id = record("id").Value;
              obj.AttachmentName = record("AttachmentName").Value;
              obj.Incident = record("Incident").Value;
              obj.Creator = record("Creator").Value;
              obj.Content = record("Content").Value;
              obj.MimeType = record("MimeType").Value;
              
              return obj;
            }
        }

      //Public members
      return{

          //Create a new Attachment.
          //true - if successful, false otherwise
          Insert : function (obj){
              var strSQL , objCommand, execResult;
              strSQL=   " Insert into [Attachment] (   [AttachmentName] ,  [Incident] ,  [Creator] ,  [Content] ,  [MimeType] )" +
              " Values (  ?,  ?,  ?,  ?,  ?); " +
              " SELECT SCOPE_IDENTITY()  " ;
              
              objCommand = Db.GetCommand(strSQL, new Array(   obj.AttachmentName,  obj.Incident,  obj.Creator,  obj.Content,  obj.MimeType ) );
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

          // Update the Attachment
          Update : function (obj){
              var strSQL, objCommand;
              strSQL= "Update [Attachment] set   [AttachmentName]=? ,  [Incident]=? ,  [Creator]=? ,  [Content]=? ,  [MimeType]=?   Where id = ? " ;
              objCommand = Db.GetCommand(strSQL, new Array(  obj.AttachmentName,   obj.Incident,   obj.Creator,   obj.Content,   obj.MimeType,    obj.id));

              if (objCommand!=null){
                  objCommand.Execute();
                  objCommand = null;
                  return true;
              }
              else{
                  return false;
              }
          },

          // Delete the Attachment
          Delete : function (id){
              var strSQL, objCommand;
              strSQL= "DELETE FROM [Attachment] WHERE id = ?";
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

          // Select the Attachment by ID
          // return Attachment object - if successful, null otherwise
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

          // Select all Attachments into a Array
          // return a Array of Attachment objects - if successful, null otherwise
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

          // Select all Attachments into a Array
          // return a Array of Attachment objects - if successful, null otherwise
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
                      obj = {id : records("id").Value ,  name: records("AttachmentName").Value };
                      returnValue.push (obj);
                      records.movenext();
                  }
                  records.Close(); records = null; objCommand = null;
                  return returnValue;
              }
          },

          // Select all Attachments into a Array
          // return a Array of Attachment objects - if successful, null otherwise
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

          // Select all Attachments into a Array
          // return a Array of Attachment objects - if successful, null otherwise
          SelectPage : function (page, nrecords, order){
              var records, objCommand, strSQL
              var rStart = new String( 1+ ((page-1)*nrecords));
              var rEnd = new String (page*nrecords);

              strSQL = "WITH CTE AS (select *, row_number() over(order by " + order + ") as rn from [Attachment] )" +
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
        
          // Select all Attachments into a Array
          // return a Array of Project objects - if successful, null otherwise
          Search : function (value){
              var records, objCommand, strSQL;
              //(1=2) is a fake condition needed here because of codegenerator, may remove it in production code
              strSQL = selectSQL + " where (1=2) "  + " or (AttachmentName like '%" + value + "%') "         + " or (  Content like '%" + value + "%') "         + " or (MimeType like '%" + value + "%') "        ;
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

          // Count Attachments
          // return Counter - if successful, null otherwise
          Count : function(){
              var strSQL, record, objCommand, returnValue;
              strSQL = "SELECT Count(id) as [Counter] FROM [Attachment] ";
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
    })(); //end AttachmentHelper
    %>
  