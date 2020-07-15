ruleset journal {
  meta {
    shares __testing, getEntries
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , {"name": "getEntries"}
      ] , "events":
      [ { "domain": "journal", "type": "new_entry", "attrs": ["message"] }
      , { "domain": "journal", "type": "new_entry" }
      , { "domain": "journal", "type": "restart" }
      ]
    }
    
    getEntries = function() {
      ent:entries
    }
  }
  
  rule set {
    select when journal new_entry
    pre {
      message = event:attrs{"message"}
      time = time:now()
      entry = {"timestamp": time, "message": message}
    }
    if message then send_directive("New Journal Entry")
    fired {
      ent:entries := ent:entries.append(entry)
    }
  }
  
  rule restart {
    select when journal restart
    pre {
      
    }
    always {
      clear ent:entries
    }
  }
}
