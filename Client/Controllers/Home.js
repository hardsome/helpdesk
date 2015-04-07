   var HomeController = {

        //get the view and model and update the DOM
        GetMenu: function(args){
            var view=null, model=null;
            args = null;
            
            //then localy render the model in the view, and update the DOM
            var UpdateDOM = function(Model,View) {
                if (Model != null){ model = Model; }
                if (View != null){ view = View; }
                if ((model != null) && (view != null)) {
                    var templateOutput = Mustache.render(view, model);
                    if ($('li.dropdown').length>0){
                        $('li.dropdown').remove();
                    }
					          $('ul.nav').append(templateOutput);
                    NormalizeHash();
                }
            }
           
            //call for the model, async
			DB.Execute( "filesystem", "Home","GetMenu",  null, UpdateDOM);
            
            //get the view, async
            ViewProxy(UpdateDOM, 'Home','GetMenu');
            
        },
        //clear local cache
        ClearCache: function(){
            ViewProxy(function () { }, 'ViewCache', 'clear');
			NormalizeHash();
        }
        
	}

      //add to list of allowed controllers/actions
      controllers['Home']=HomeController;
