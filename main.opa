import jQueryUI
import stdlib.web.canvas


myCount = Mutable.make(0);
type bubble = {string id,string title, int x, int y, int h, int w, int open}

//database synappz {
//  bubble /bubbles[{id}]
//}
function draw_line(canvas_dom,parent_element,element){
  p_pos=Dom.get_position(parent_element);
  pos=Dom.get_position(element);

  // mycan = Canvas.get(#myCanvas);
  mycan = Canvas.get(canvas_dom);
  match(mycan){
  case {none}:{};

  case {some:mycan}:
      {
          //mycan=Canvas.get(#test);
        Canvas.canvas meincan=mycan;
      mytext=Canvas.get_context_2d(mycan);
      match(mytext){
        case{none}:{}
        case{some:mytext}:
          {
            Canvas.clear_rect(mytext,0,0,500,500);

            Canvas.begin_path(mytext);
            Canvas.move_to(mytext,p_pos.x_px+35,p_pos.y_px+35);
            Canvas.line_to(mytext,pos.x_px+35,pos.y_px+35);
            Canvas.stroke(mytext);
          }
      }
      
    };
  }

}

function on_drag(){
  myevent=#draggableDataEvent;
  text=Dom.get_content(myevent);
  nr=String.drop_left(9,text);
  text="canvas{nr}";
  canvas=#{text};

  text="draggable{nr}";
  element=#{text};


  draw_line(canvas,#draggable0,element);

  //#dragContainer =+"dragged around:{text}!"
  
}

function on_resize_stop(){
  
  // myevent=#resizableData;
  ///bubbles[key]
  #dragContainer =+ "<div>it was </div>"

}
function mk_draggresizable(dom element){
  mk_draggable(element);
  mk_resizable(element);
}
function mk_draggresizable_c(dom element){
  mk_draggable_c(element);
  mk_resizable_c(element);
}
function mk_draggable(dom element) {
  //jQueryUI.Draggable.mk_draggable(#draggable)
  //jQueryUI.Draggable.mk_draggable(Dom.select_class("draggable"))
  jQueryUI.Draggable.mk_draggable(element)
  //jQueryUI.Draggable.on_drag(element, on_drag)
  //jQueryUI.Resizable.mk_resizable(Dom.select_class("draggable"))
//  jQueryUI.Resizable.on_stop(Dom.select_class("draggable"), on_resize_stop())

}
function mk_draggable_c(dom element){
  jQueryUI.Draggable.mk_draggable(Dom.select_class("draggable"))
  jQueryUI.Draggable.on_drag(element, on_drag)
}
function mk_resizable(dom element){
  jQueryUI.Resizable.mk_resizable(element)
  //jQueryUI.Resizable.on_stop(element, on_resize_stop)
}
function mk_resizable_c(dom element){
  jQueryUI.Resizable.mk_resizable(element)
  jQueryUI.Resizable.on_stop(element, on_resize_stop)
}

function click_new( parent_element ){
  int counter=myCount.get();
  counter = counter + 1;
  string name="draggable{counter}"; 
  string canvas_name="canvas{counter}";
  
  dom element=#{name};
  dom canvas_dom=#{canvas_name};

  myCount.set(counter);

  #dragContainer =+ <div id={name} class=draggable onready={function(_){ mk_draggresizable_c(element) } }>
      <span onClick={function(_){click_new( element )}}>New</span><br>
      <span onClick={function(_){open( counter )}}>Open</span><br>
      <span onClick={function(_){close( counter )}}>Close</span>
    </div>;

  #lineContainer =+ <canvas id="{canvas_name}" class="line" height="500" width="500"></canvas>;
  draw_line(canvas_dom,parent_element,element);
}
function open(nr){
  name = "widget{nr}";
  dom element = #{name};
  #widgetContainer =+ <div id="widget{nr}" class="widget" onready={function(_){mk_draggresizable(element)}}>widget</div>;
  int height=350;
  int width=350;
  Dom.set_height(element,height);
  Dom.set_width(element,width);
}
function close(nr){
  name = "widget{nr}";
  dom element = #{name};
  Dom.remove(element);
}
function show_mindmap(_){
  Dom.hide(#widgetContainer);
  Dom.show(#dragContainer);
  Dom.show(#lineContainer);
}
function show_content(_){
  Dom.hide(#dragContainer);
  Dom.hide(#lineContainer);
  Dom.show(#widgetContainer);
}
function show_mindmap_content(_){
  Dom.show(#widgetContainer);
  Dom.show(#dragContainer);
  Dom.show(#lineContainer);
}

function page() {
  <span onClick={show_mindmap}> Mindmap</span>
  <span onClick={show_content}> Content</span>
  <span onClick={show_mindmap_content}> both</span>
  <div id="dragContainer">
    <div id=draggable0 class=draggable  onready={function(_){ mk_draggresizable_c(#draggable0) } }>   
      <span onClick={function(_){click_new(#draggable0)}}>New</span><br>
      <span onClick={function(_){open(0)}}>Open</span><br>
      <span onClick={function(_){close(0)}}>Close</span>
      
    </div>
  </div>
  <div id="lineContainer">
  </div>
  <div id="widgetContainer">
  </div>
  <div id=data>
    <div id=resizableData></div>
    <div id=draggableData></div>
  </div>
  //<div id=resizable class=resizable onready={mk_resizable}> bla </div>
}

Server.start(Server.http,
  [ {resources: @static_resource_directory("resources")}
  , {register:{css: ["resources/bootstrap.css", "resources/main.css", "resources/jquery.css"]}}
  , {title: "synappz", ~page}
  ]
)
