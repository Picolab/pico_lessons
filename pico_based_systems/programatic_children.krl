ruleset programatic_children {

  meta {
    name "Programatic Children"
    
    description "Ruleset for Pico Lesson on Pico Based Systems"

    author "PJW"

    use module v1_wrangler alias wrangler

    sharing on

    provides showChildren

  }

  global {

    showChildren = function() {
      wrangler:children();
    }
  
  }

  rule createAChild {
    select when pico_systems child_requested
    pre{
      name = "Test_Child_" + math:random(999);
    }
    {
      wrangler:createChild(name);
    }
    always{
      log("create child names " + name);
    }
  }

  rule deleteAChild {
    select when pico_systems child_deletion_requested
    pre {
      name = event:attr("name");
    }
    if(not name.isnull()) then {
      wrangler:deleteChild(name)
    }
    fired {
      log "Deleted child named " + name;
    } else {
      log "No child named " + name;
    }

  }
}