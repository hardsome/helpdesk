

      <%
    Model = null;
    ViewData = null;
    


    var HomeController = {
            Index: function(){
                Model = {
                    title : "helpdesk", 
                    metadescription : "Classic ASP MVC for dynamic JavaScript pages",
                    baseurl : baseurl,
                    brand : "helpdesk",
                    searchtext : "search",
                    mainblockheader : "Classic ASP MVC for dynamic JavaScript pages",
                    mainblocktext : "To view an article on how this code works go here: http://www.codeproject.com/Articles/706216/Classic-ASP-MVC-for-dynamic-JavaScript-pages",
                    mainblocklink : "http://www.codeproject.com/Articles/706216/Classic-ASP-MVC-for-dynamic-JavaScript-pages"
                };
                 %>   <!--#include file="../Views/Home/Index.asp" --> <%            
            },
            
            About: function(){
                if (isNaN(Number(Session("sessionCounter")))){
                    Session("sessionCounter") = 1;
                }
                else{
                    Session("sessionCounter") = new Number(Session("sessionCounter")) + 1;
                }
                Model = Session("sessionCounter");
                %>   <!--#include file="../Views/Home/About.asp" --> <%  
            },
            GetMenu: function(callback, vars){
                var anchors = new Array();
				        
                anchors.push({link : '#/Project/List', linktext: 'Project'});
                anchors.push({link : '#/User/List', linktext: 'User'});
                anchors.push({link : '#/Status/List', linktext: 'Status'});
                anchors.push({link : '#/Priority/List', linktext: 'Priority'});
                anchors.push({link : '#/Category/List', linktext: 'Category'});
                anchors.push({link : '#/Incident/List', linktext: 'Incident'});
                anchors.push({link : '#/Post/List', linktext: 'Post'});
                anchors.push({link : '#/Attachment/List', linktext: 'Attachment'});
                anchors.push({link : '#/Home/ClearCache', linktext: 'Clear cache'});
                var model = {data : anchors};
                callback(JSON.stringify(model),"application/json") ;
            }
            
            
    };
      //list of allowed controller/action
      controllers['Home']=HomeController;

   %> 
    