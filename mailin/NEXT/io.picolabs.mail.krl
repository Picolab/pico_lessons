ruleset io.picolabs.mail {
  meta {
    provides parse
  }
  global {
    __testing = { "events": [ { "domain": "mail", "type": "parsed",
                                "attrs": [ "to", "text" ] } ] }
    newline = (13.chr() + "?" + 10.chr()).as("RegExp")
    var = function(s) {
      p = s.split(re#=#);
      {}.put(p[0],p[1])
    }
    vars = function(s) {
      p = s=>s.split(re#&#)|[];
      p.reduce(function(a,b){a.put(var(b))},{})
    }
    parse = function(text,domain) {
      dlpo = domain.length() + 1;
      text.split(newline)
          .filter(function(v){p=v.split(re#/#);p[0]==domain && p.length()==2})
          .map(function(v){p=v.split(re#[?]#);[p[0].substr(dlpo),vars(p[1])]})
    }
  }

  rule mail_incoming {
    select when mail received
    pre {
      attrs = event:attrs.klog("attrs")
      headers = attrs{"headers"}
      date = headers{"Date"}.klog("date")
      to = headers{"To"}.klog("to")
      from = headers{"From"}.klog("from")
      subject = headers{"Subject"}.klog("subject")
      text = attrs{"plain"}.klog("text")
    }
    fired {
      raise mail event "parsed" attributes
        { "date":date, "to":to, "from":from, "subject":subject, "text":text }
    }
  }

  rule mail_router {
    select when mail parsed to re#[+]([^@]*)@cloudmailin.net# setting(eci)
    event:send({"eci":eci, "domain":"mail", "type":"events", "attrs":event:attrs})
  }
}
