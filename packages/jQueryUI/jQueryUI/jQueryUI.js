##extern-type Dom.private.element

##register mk_sortable: Dom.private.element -> void
##args(dom)
{
    dom.sortable();
    return js_void;
}

##register disable_selection: Dom.private.element -> void
##args(dom)
{
    dom.disableSelection();
    return js_void;
}

##register sortable_on_update : Dom.private.element, ( -> void) -> void
##args(dom, on_update)
{
return dom.bind( "sortupdate", function(event, ui) { on_update(); } );
}

##register mk_draggable: Dom.private.element -> void
##args(dom)
{
    dom.draggable();
    return js_void;
}

##register mk_resizable: Dom.private.element -> void
##args(dom)
{
    dom.resizable();
    return js_void;
}

##register resizable_on_stop : Dom.private.element, ( -> void) -> void
##args(dom, on_stop)
{
  //return dom.bind( "resizestop", function(event, ui) { on_stop(); } );

  return dom.bind( "resizestop", 
  		function(event, ui) { 
  	 	  
   		  //item ="<div>we made it</div>";
          //domitem=Dom.of_xhtml(item);
          //Dom.put_at_end(dom,domitem);
          document.getElementById("resizableData").innerHTML = "<div id='event'>"+event.target.id+"</div>";
          document.getElementById("resizableData").innerHTML += "<div id='width'>"+ui.size.width+"</div>";
          document.getElementById("resizableData").innerHTML += "<div id='height'>"+ui.size.height+"</div>";
           on_stop();
   		} );
  
  //return dom.bind_with_options( "resizestop", function(event, ui) { on_stop(); }, );
}