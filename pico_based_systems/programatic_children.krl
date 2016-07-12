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
      random_name = "Test_Child_" + math:random(999);
      name = event:attr("name").defaultsTo(random_name);
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

  rule installRulesetInChild {
    select when pico_systems ruleset_install_requested
    pre {
      rid = event:attr("rid");
      pico_name = event:attr("name");
    }
    wrangler:installRulesets(rid) with
      name = pico_name
  }

}