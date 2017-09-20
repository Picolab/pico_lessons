ruleset aurora_test {
  meta {
    shares __testing
    use module io.picolabs.mail alias mail
  }
  global {
    __testing = { "queries": [ { "name": "__testing" } ],
                  "events": [ { "domain": "mail", "type": "events",
                                "attrs": [ "text" ] } ] }
  }
  rule mail_events {
    select when mail events
    foreach mail:parse(event:attr("text"),"aurora") setting(request)
    pre {
      type = request[0];
      attrs = request[1];
    }
    if request.length() == 2 then send_directive(type,attrs);
    fired {
      raise aurora event type attributes attrs;
      ent:lastRequest := "aurora/"+type;
      ent:lastAttrs := attrs;
    }
  }
}
