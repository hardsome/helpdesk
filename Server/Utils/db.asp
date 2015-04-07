<%
//MS SQL access helper for JavaScript
var Db = (function(){
	var adCmdUnknown = 8;
	var adCmdText = 1;
	var adCmdTable = 2;	
	var adCmdStoredProc = 4;

	var oConn ;
	oConn = null;
	
	
	var SafeValue = function (param, value){
 
		if (String(value) === ""){
			return null;
		}
		else{   
			switch (param.Type){
				case 129:
				case 130:
				case 200:
				case 201:
				case 202:
				case 203:
					if ((param.Size!=-1) & (String(value).length> param.Size)){
						 new Exception("db utilites: DBSafeAssign ", "string is too long(" + value + ")");
					}
					return new String(value);
					break;
				case 72: 
					return new String(value);
					break;
				case 7:
				case 135: 
					return new Date(value).getVarDate();
					break;
				case 20:
				case 3:
				case 131:
				case 2:
				case 17 :
					if (isNaN(value)){
						return null;
					}
					else{	
						return new Number(value);
					}
					break;
				case 4:
				case 5:
				case 14:
				case 6: 
				    if (isNaN(value)){
						return null;
					}
					else{	
						return new Number(value);
					}
					break;
				case 11: 
					return  new Boolean(value);
					break;
				default:
				  new Exception( "db utilites: DBSafeAssign ", "unsupported type(" + param.Type + ") of database field");
			}
		}
	};

	var OpenConnection = function (){
	   if (oConn===null){
		  oConn = createobject("ADODB.Connection")
		  oConn.Mode = 3
		  oConn.ConnectionString = config.connectionString;
		  oConn.Open();
	   }
	   return oConn;
	};
	
	var AddParameters = function ( objCommand,  values){
		if (!values instanceof Array){
			return false;
		}	
		if (objCommand.Parameters.Count === values.length) {
			for (i=0; i< objCommand.Parameters.Count ;i++){
				//objCommand.Parameters(i) = values(i);
				try{
					objCommand.Parameters(i).Value = SafeValue  (objCommand.Parameters(i), values[i]);
				}
				catch(err){
					new Exception("value(s) are not valid!")
				}   
			}
			return true;
		}
		else{
			return false;
		}
	};   


    //Public members
    return{

		 CloseConnection : function (){
		   if (oConn===null){
			  oConn.Close();                   
			  oConn = null;
		   }
		   return oConn;
		 },
		 
		 GetCommand : function(strSQL, params){
            objCommand=createobject("ADODB.command") ;
            objCommand.ActiveConnection=OpenConnection();
            objCommand.NamedParameters = false;
            objCommand.CommandText = strSQL;
            objCommand.CommandType = adCmdText;
            if (params){
				if (AddParameters(objCommand,params))
					return objCommand;
				else
					return null;
			}
			else
				return objCommand;
		 },

		Execute : function (sql, params){
		   var oConnection;
		   oConnection = OpenConnection();
		   return oConnection.execute(sql);
		}

    }//end public members
})(); //end Db




%>