

/*
Client side controller work with different databases
thus it should be more strict.
protocol: CRUDL+
Server side Model is processed by a Server side controller, and may have sophisticated logic.
File system Model is just saved .json files and can be as complex as you need it.
In case of working with localstorage more (of that sophisticated) logic can be shifted to Client side Model.
co calling for model may look like this
            //call to DB layer for the model, to localstorage, remoteserver or filesystem
            DB.Execute( "filesystem",   "Project","List",  args, UpdateDOM);
            DB.Execute( "remoteserver", "Project","List",  args, UpdateDOM);
            DB.Execute( "localstorage", "Project","List",  args, UpdateDOM);
            //or call to Client side Model layer for the model 
            ProjectHelper.List(args, UpdateDOM);
It should be always async, with callbacks. "UpdateDOM" - name of callback function, that is part of Client side Controller.

*/

      var ProjectController = {
        List: function(args, callback){
            var view=null, model=null;
            
            //locally render the model in the view when they are ready, and update the DOM
            var UpdateDOM = function(Model,View) {
                if (Model != null){ model = Model; }
                if (View != null){ view = View; }
                if ((model != null) && (view != null)) {
                    //you should be able to  render the model directly into the view
                    //but you could check the model for known values like  //if (Model.somebooleanvalue==true){}
                    //render the Model into the Template
                    var templateOutput = Mustache.render(view, model);
                    //update the DOM:
                    $("#dialog1-body").empty();
                    $("#dialog1-body").append(templateOutput);
                    $("#dialog1-label").empty().append("list of Project");
                    $("#dialog1").modal("show");
                }
            }
            
            //call for the model, async 
            ProjectHelper.List(args,UpdateDOM);
            
            //get the view, async
            ViewProxy(UpdateDOM, 'Project','List');
            
        },
        
        //get the view and model and update the DOM
        Create: function(args, callback){
            var view=null, model=null;
            
            //locally render the model in the view when they are ready, and update the DOM
            var UpdateDOM = function(Model,View) {
                if (Model != null){ model = Model; }
                if (View != null){ view = View; }
                if ((model != null) && (view != null)) {
                    var templateOutput = Mustache.render(view, model);
                    $("#dialog2-body").empty();
                    $("#dialog2-body").append(templateOutput);
                    $("#dialog2-label").empty().append("Create new Project");
                    $("#dialog2").modal("show");
                    
                }
            }
           
            //call for the model, now just create an object and call the callback to update the interface
            UpdateDOM ({data : new DataModel.Project()});
            
            //get the view, async
            ViewProxy(UpdateDOM, 'Project','Create');
            
        },
        
        //this is called from dynamic script from the /Client/Views/Project/Create.html
        CreatePost: function(args, callback){
            var view=null, model=null;
            
            //locally render the model in the view when they are ready, and update the DOM
            var UpdateDOM = function(Model,View) {
                if (Model != null){ model = Model; }
                if (View != null){ view = View; }
                
                //may show the form/components on the client here
                if ((model != null) && (view != null)) {
                    if (model.result == true) {
                        $("#dialog2-body").empty();
                        $("#dialog2-label").empty();
                        $("#dialog2").modal("hide");
                        NormalizeHash();
                        var templateOutput = Mustache.render(view, model);
                        //find the table Projectdatatable 
                        //find the last row  and inset the row with Attribute rowid='id'
                    
                        if ($("#Projectdatatable")[0]!=undefined){
                           $("#Projectdatatable tbody").append(templateOutput);
                           ProjectListModule.bindEvents();
                        }
                        
                    }
                    if (model.result == false) {
                        var templateOutput = Mustache.render(view, { error: model.result });
                        $("#dialog2-label").empty().append(templateOutput);
                    }
                }
            }
            
            //call for the model, async
            ProjectHelper.Create(args, UpdateDOM);
             
            //get the view, async
            ViewProxy(UpdateDOM, 'Project','CreatePost');

        },

        //get the view and model and update the DOM
        Edit: function(args, callback){
            var view=null, model=null;
            
            var UpdateDOM = function(Model,View) {
                if (Model != null){ model = Model; }
                if (View != null) { view = View; }
                if ((model != null) && (view != null)) {
                    var templateOutput = Mustache.render(view, model);
                    $("#dialog2-body").empty();
                    $("#dialog2-body").append(templateOutput);
                    $("#dialog2-label").empty().append("Update Project");
                    $("#dialog2").modal("show");
                    
                }
            }
            
            //call for the model, async
            ProjectHelper.Read(args, UpdateDOM);
          
            //get the view, async
            ViewProxy(UpdateDOM, 'Project','Edit');
            
        },

        //this is called after receiving Template, Model of the post form
        //dynamic script from the /Client/Views/Project/Edit.html ? local router ? controller proxy ? server router ? server ProjectController.EditPost ? try render ? local ProjectController.EditPost
        EditPost: function(args, callback){
            var view=null, model=null;
            var id=args.id;
            
            var UpdateDOM = function(Model,View) {
                if (Model != null){ model = Model; }
                if (View != null) { view = View; }
                
                //may show the form/components on the client here
                if ((model != null) && (view != null)) {
                    if (model.result == true) {
                        $("#dialog2-body").empty();
                        $("#dialog2-label").empty();
                        $("#dialog2").modal("hide");
                        /*update the list if opened*/
                        //ProjectController.Row(null,id);
                        //call the separate action 'row' or receive the data here
                        var templateOutput = Mustache.render(view, model);
                        //find the table Projectdatatable 
                        //find the row with Attribute rowid='id' and replace the row 
                    
                        if ($("#Projectdatatable")[0]!=undefined){
                           $("#Projectdatatable tr[rowid='" + model.data.id + "']").empty().append(templateOutput);
                        }

                    }
                    if (model.result == false) {
                        var templateOutput = Mustache.render(view, { error: model.result });
                        $("#dialog2-label").empty().append(templateOutput);
                    }
                }
            }
            
            //call for the model, async
            ProjectHelper.Update(args,UpdateDOM);
            
            //get the view, async
            ViewProxy(UpdateDOM, 'Project','EditPost');

        },

        //is called on before deletion of element. select element from database and display deletion form
        Delete: function(args, callback){
            var view=null, model=null;
            
            var UpdateDOM = function(Model,View) {
                if (Model != null){ model = Model; }
                if (View != null) { view = View; }
                if ((model != null) && (view != null)) {
                    var templateOutput = Mustache.render(view, model);
                    $("#dialog2-body").empty();
                    $("#dialog2-body").append(templateOutput);
                    $("#dialog2-label").empty().append("Delete Project");
                    $("#dialog2").modal("show");
                }
            }
            
            //call for the model, async
            ProjectHelper.Read(args, UpdateDOM);
            
            //get the view, async
            ViewProxy(UpdateDOM, 'Project','Delete');

        },

        //called on confirm deletion of element
        DeletePost: function(args, callback){
            var view=null, model=null;
            
            var UpdateDOM = function(Model,View) {
                if (Model != null){ model = Model; }
                if (View != null) { view = View; }

                //may show the form/components on the client here
                if ((model != null) && (view != null)) {
                    if (model.result == true) {
                        $("#dialog2-body").empty();
                        $("#dialog2-label").empty();
                        $("#dialog2").modal("hide");
                        //find the table Projectdatatable 
                        //find the row with Attribute rowid='id' and delete the row 
                    
                        if ($("#Projectdatatable")[0]!=undefined){
                           $("#Projectdatatable tr[rowid='" + model.data.id + "']").remove();
                           ProjectListModule.disableButtons();
                        }

                    }
                    if (model.result == false) {
                        var templateOutput = Mustache.render(view, { error: model.result });
                        $("#dialog2-label").empty().append(templateOutput);
                    }
                }
            }
            
            //call for the model, async
            ProjectHelper.Delete(args,UpdateDOM);
            
            //get the view, async
            ViewProxy(UpdateDOM, 'Project','DeletePost');
      },

      Details: function (args, callback){
          var view=null, model=null;

          var UpdateDOM = function(Model,View) {
              if (Model != null){ model = Model; }
              if (View != null) { view = View; }
              if ((model != null) && (view != null)) {
                    var templateOutput = Mustache.render(view, model);
                    $("#dialog2-body").empty();
                    $("#dialog2-body").append(templateOutput);
                    $("#dialog2-label").empty().append("Details on Project");
                    $("#dialog2").modal("show");
              }
          }
                
          //call for the model, async
          ProjectHelper.Read(args, UpdateDOM);
          
          //get the view, async
          ViewProxy(UpdateDOM, 'Project','Details');
      },
        
      //call to get values for dropdown
      //should be cached throughout
      //is called from code, not from router
      //args - an ID of Select where values are insert to
      DropDown: function (args, callback){
          if ($(args).length!=1) return;
          var view=null, model=null;
          var oldvalue = $(args).val();   
          var UpdateDOM = function(Model,View) {
              if (Model != null){ model = Model; }
              if (View != null) { view = View; }
              if ((model != null) && (view != null)) {
                  var templateOutput = Mustache.render(view, model);
                  if ($(args).length ) {     
                  $(args).empty()
                    .append("<option value=''>-- Select One --</option>")
                    .append(templateOutput);
                  $(args).val(oldvalue);
                  }
              }
          }

          //call for the model, async
          ProjectHelper.DropDown(args, UpdateDOM);
          
          //get the view, async
          ViewProxy(UpdateDOM, 'Project','DropDown');
      },

      About: function(args, callback) {
          var view = null, model = null;

          //locally render the model in the view when they are ready, and update the DOM
          var UpdateDOM = function(Model, View) {
              if (Model != null) { model = Model; }
              if (View != null) { view = View; }
              if ((model != null) && (view != null)) {
                  //you should be able to  render the model directly into the view
                  //but you could check the model for known values like  //if (Model.somebooleanvalue==true){}
                  //render the Model into the Template
                  var templateOutput = Mustache.render(view, model);
                  //update the DOM:
                  $("#dialog3-body").empty();
                  $("#dialog3-body").append(templateOutput);
                  $("#dialog3-label").empty().append("Information");
                  $("#dialog3").modal("show");
              }
          }
          //dumb model (if needed you can get something from server)
          model = { data: true };

          //get the view, async
          ViewProxy(UpdateDOM, 'Project', 'About');

      }
        
  };
/*end of Project  Controller*/

//add to list of allowed controllers/actions
controllers['Project']=ProjectController;

    