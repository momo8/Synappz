package myapp.wiki

import stdlib.themes.bootstrap
import stdlib.tools.markdown
database stringmap(string) /wiki
database /wiki[_] ="Diese Seite ist leer. Doppelt klicken, um sie zu bearbeiten";

module wiki {
  /*demo =
    { name: "Draggable"
    , pages:
        [ {name: "drag"            , show: on_update_demo }
        ]
    }*/






exposed function load_source(topic){
  /wiki[topic];
}

function load_rendered(topic){
  source = load_source(topic);
  Markdown.xhtml_of_string(Markdown.default_options, source);
}

exposed function save_source(topic, source){
  /wiki[topic]<-source;
  load_rendered(topic);
}

function display(topic){
//<div class="page-header"><h1>About {topic}</h1></div>
    <div>
      
      <div id=#show_content ondblclick={function(_) {edit(topic)}}>{load_rendered(topic)}</div>
      <textarea class="wiki_textarea" style="display:none" rows="15" id=#edit_content onblur={function(_) { save(topic) }}> </>
    </div>


  /*
  Resource.styled_page("About {topic}",["/resources/css.css"],
    <div class="topbar"><div class="fill"><div class="container"><div id=#logo></div></div></div></div>
    <div class="content container">
      <div class="page-header"><h1>About {topic}</h1></div>
      <div class="well" id=#show_content ondblclick={function(_) {edit(topic)}}>{load_rendered(topic)}</div>
      <textarea rows="30" id=#edit_content onblur={function(_) { save(topic) }}> </>
    </div>
);*/
}

function edit(topic){
  Dom.set_value(#edit_content, load_source(topic));
  Dom.hide(#show_content);
  Dom.show(#edit_content);
  Dom.give_focus(#edit_content);
}

function save(topic){
  content = save_source(topic, Dom.get_value(#edit_content));
  #show_content = content;
  Dom.hide(#edit_content);
  Dom.show(#show_content);
}

function remove_topic(topic){

  Db.remove(@/wiki[topic]);

}
function topic_of_path(path){
  String.capitalize(String.to_lower(List.to_string_using("", "","::",path)));
}

function rest(topic){
  match(HttpRequest.get_method()){
  case{some:method}:
    match(method){
    case {post}:
      _=save_source(
	topic,
	match(HttpRequest.get_body()){
	  case ~{some}:some;
	  case {none}:"";
	}
      );
      Resource.raw_status({success});
    case {delete}:
      remove_topic(topic);
      Resource.raw_status({success});
    case {get}:
      Resource.raw_response(load_source(topic),"text/plain",{success});
    default:
      Resource.raw_status({method_not_allowed});
    }
  default:
    Resource.raw_status({bad_request});
  }
}

  function page(string element_name) {
    #{element_name} = display(element_name);

  }
}
