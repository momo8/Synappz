import jQueryUI
import stdlib.web.canvas


myCount = Mutable.make(0); 

type draggable = {string name, string father, list(string) childs}
type dragglist = list(draggable);
//dragglist mylist = Mutable.make({"draggable0","fater",{}});

//mymap = StringMap.empty;
//mymap = StringMap.add("rabbit", 12, mymap)
mymap = StringMap.empty;
mymap = StringMap.add("draggable0","draggable1",mymap);

/*
* add a new bubble
*/
function ds_add_bubble(string parent_element_name,string element_name){
  //verknüpfung des faters zum neuen element hinzufügen
  //ds_add_link(parent_element,element);
  
  //neues element eintragen
  // myelement={name:element_name,father:parent_element_name}
  //List.add(myelement,mylist);
  //StringMap.add(element_name,myelement,mymap);

  StringMap.add(element_name,parent_element_name,mymap);
}

//Map.fold(function( key, value, acc ) {
function ds_get_father(string element_name){
  element=Map.get("draggable0",mymap);
  match(element){
    case {none}:{}
    case {some:string element}:{
       element
    }
  }
}

/*
* Adds a connection
* param1: String element
*         element to append
*/
/*
function ds_add_link(string parent_element, string element){ //expecting string similar to: draggable0
  //List.add(element,mylist.childs);
  ;
}
*/


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
  Log.info("canvasnr",text);
  canvas=#{text};

  
  text="draggable{nr}";
  element=#{text};


  text="draggable{nr}parent";
  element2=#{text};
  text=Dom.get_text(element2);

  if(text!=""){
    element2=#{text};
    draw_line(canvas,element2,element);
  }

  text="draggable{nr}counter";
  element2=#{text};
  text=Dom.get_text(element2);

  option(int) int_nr = Parser.try_parse(Rule.integer, text)
  match(int_nr){
    case{none}:{}
    case{some:int_nr}:
    { 
      draw_line_to_child(element,nr,int_nr,0)
      // text="draggable{nr}child{int_nr}";
      // #{text} = int_nr+1;
    }
  }
}
function draw_line_to_child(element,nr,int int_nr,int i){
  
  //Log.info("int_nr",int_nr);
  //Log.info("i",i);
  if(i<int_nr){
    text="draggable{nr}child{i}";
    Log.info("text",text);
    element2=#{text};
    text=Dom.get_content(element2);
    Log.info("text2_get_text",text)
    element2=#{text};

    //which canvas:
    canvas_nr=String.drop_left(9,text);
    canvas_name="canvas{canvas_nr}";
    canvas=#{canvas_name};


    draw_line(canvas,element2,element);
    int j = i+1;
    draw_line_to_child(element,nr,int_nr,j)
  }
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

function click_new(string parent_element_name ){
  int counter=myCount.get();
  counter = counter + 1;
  string name="draggable{counter}"; 
  string canvas_name="canvas{counter}";
  
  dom element=#{name};
  dom canvas_dom=#{canvas_name};

  myCount.set(counter);
  string herbert="test";
  #draggContainer =+ <div></div>;


  text1="draggable{counter}parent";
  text2="draggable{counter}childs";
  text3="draggable{counter}counter";

  #dragContainer =+ <div id={name} class=draggable onready={function(_){ mk_draggable_c(element) } }>
      <span onClick={function(_){click_new( name )}}>New</span><br>
      <span onClick={function(_){open( counter )}}>Open</span><br>
      <span onClick={function(_){close( counter )}}>Close</span>
      <div class=hidden id={text1}>{parent_element_name}</div>
      <div class=hidden id={text2}></div>
      <div class=hidden id={text3}>0</div>
    </div>;


  #lineContainer =+ <canvas id="{canvas_name}" class="line" height="500" width="500"></canvas>;
  parent_element=#{parent_element_name};
  parent_child_element_name="{parent_element_name}childs";
  text="{parent_element_name}counter";
  // #{parent_child_element_name} =+ "<div id={parent_child_element_name}>{name}</div>";
  
  pcounter = #{text};
  pc = Dom.get_content(pcounter);
  // pc=pc+1;
  int my_nr=0;
  option(int) int_nr = Parser.try_parse(Rule.integer, pc)
    match(int_nr){
        case{none}:{}
        case{some:int_nr}:
          {
          //Log.info("my_nr",my_nr);
          //Log.info("int_nr",int_nr);
          my_nr=int_nr;
          #{text} = int_nr+1;
        }
  }
  text="{parent_element_name}child{my_nr}";
  #{parent_child_element_name} =+ <div id="{text}">{name}</div>;



  //#{text3} = pc;
  //ds_add_bubble(name,parent_element_name);
  draw_line(canvas_dom,parent_element,element);

  //add to db
  /*
  text=Dom.get_content(parent_element);
  nr=String.drop_left(9,text);
  int_nr = Parser.try_parse(Rule.integer, nr)
  match(int_nr){
    case {none}:{}
    case {some:int_nr}:{
      db_new_draggable(counter,int_nr);
    }
  }
  */

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
  <span onClick={show_mindmap}><a> Mindmap</a></span>
  <span onClick={show_content}><a> Content</a></span>
  <span onClick={show_mindmap_content}><a> both</a></span>
  <div id="dragContainer" style="height:0px;">
    <div id=draggable0 class=draggable  onready={function(_){ mk_draggable_c(#draggable0) } }>   
      <span onClick={function(_){click_new( "draggable0" )}}>New</span><br>
      <span onClick={function(_){open( #draggable0 )}}>Open</span><br>
      <span onClick={function(_){close( #draggable0 )}}>Close</span>
      <div class=hidden id="draggable0parent"></div>
      <div class=hidden id="draggable0childs"></div>
      <div class=hidden id="draggable0counter">0</div>
    </div>
  </div>
  <div id="lineContainer" style="height:0px;">
  </div>
  <div id="widgetContainer" style="height:0px;">
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
