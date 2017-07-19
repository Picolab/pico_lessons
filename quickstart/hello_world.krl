ruleset com.windley.hello_world {
  meta {
    name "Hello World"
    description <<
A first ruleset for the Quickstart
>>
    author "Phil Windley"
    logging on
    shares hello
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj;
      msg
    }
 
  }
  rule hello_world {
    select when echo hello
    pre {
      my_name = event:attr("name")
                   .lc()
                   .klog("Here's the name I saw: ")
                   .uc()
                 
    }
    send_directive("say", {"something": "Hello World"})
  }
 
}
