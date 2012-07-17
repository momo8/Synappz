import jQueryUI

myCount = Mutable.make(0);
type bubble = {string id,string title, int x, int y, int h, int w, int open}

//database synappz {
//  bubble /bubbles[{id}]
//}

function on_resize_stop(){
  
  ///bubbles[key]
  #dragContainer =+ "<div>done.. this!</div>"
}
function mk_draggresizable(dom element){
  mk_draggable(element);
  mk_resizable(element);
}
function mk_draggable(dom element) {
  //jQueryUI.Draggable.mk_draggable(#draggable)
  //jQueryUI.Draggable.mk_draggable(Dom.select_class("draggable"))
  jQueryUI.Draggable.mk_draggable(element)
  //jQueryUI.Resizable.mk_resizable(Dom.select_class("draggable"))
//  jQueryUI.Resizable.on_stop(Dom.select_class("draggable"), on_resize_stop())

}
function mk_resizable(dom element){
  jQueryUI.Resizable.mk_resizable(element)
  jQueryUI.Resizable.on_stop(element, on_resize_stop)
}

function click_new(_){
  int counter=myCount.get();
  counter = counter + 1;
  string name="draggable{counter}"; 
  dom element=#{name};
  myCount.set(counter);

  #dragContainer =+ <div id={name} class=draggable onready={function(_){ mk_draggresizable(element) } }>
      <span onClick={click_new}>New</span><br>
      <span onClick={function(_){open( element )}}>Open</span><br>
      <span onClick={function(_){close( element )}}>Close</span>
    </div>;
}
function open(dom element){
  int height=350;
  int width=500;
  Dom.set_height(element,height);
  Dom.set_width(element,width);
}
function close(dom element){
  int height=70;
  int width=70;
  Dom.set_height(element, height);
  Dom.set_width(element,width);
}

function page() {
  <div id="dragContainer">
    <div id=draggable0 class=draggable  onready={function(_){ mk_draggresizable(#draggable0) } }>   
      <span onClick={click_new}>New</span><br>
      <span onClick={function(_){open(#draggable0)}}>Open</span><br>
      <span onClick={function(_){close(#draggable0)}}>Close</span>
      
    </div>
  </div>
  <div id=data>
    <div id=resizableData></div>
  </div>
  //<div id=resizable class=resizable onready={mk_resizable}> bla </div>
}

Server.start(Server.http,
  [ {resources: @static_resource_directory("resources")}
  , {register:{css: ["resources/bootstrap.css", "resources/main.css", "resources/jquery.css"]}}
  , {title: "synappz", ~page}
  ]
)
