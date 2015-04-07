<%

Exception=function (errorMessage){
    Response.Clear();
    Response.Status="500 Internal Server Error";
    Response.Write(errorMessage);
    Response.End();
 }


%>