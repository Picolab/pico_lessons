ruleset hello_world {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    sharing on
    provides hello
 
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
 
  }
  rule hello_world {
    select when echo hello
    pre {
      my_name = event:attr("name")
                   .klog("Here's the name I saw");
    }
    send_directive("say") with
      something = "Hello " + my_name;
  }
 
}
