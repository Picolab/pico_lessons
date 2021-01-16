ruleset timing_tracker {
  meta {
    use module io.picolabs.wrangler alias wrangler
    shares __testing, entries
  }
  global {
    __testing = {"queries":__testing.get("queries").map(function(q){
        q.delete("args")}),
      "events":__testing.get("events").filter(function(e){
        e.get("attrs").length && e.get("domain")=="timing"})}
    entries = function() {
      ent:timings.defaultsTo({}).values()
    }
    tags = [meta:rid]
    eventPolicy = {"allow":[{"domain":"timing","name":"*"}],"deny":[]}
    queryPolicy = {"allow":[{"rid":meta:rid,"name":"*"}],"deny":[]}
  }
  rule timing_first_use {
    select when timing started or timing finished
    if ent:timings then noop()
    notfired {
      ent:timings := {}
    }
  }
  rule timing_started {
    select when timing started number re#n0*(\d+)#i setting(ordinal_string)
    pre {
      key = "N" + ordinal_string
    }
    if ent:timings >< key then noop()
    notfired {
      ent:timings{key} := {
        "ordinal": ordinal_string.as("Number"),
        "number": event:attr("number"),
        "name": event:attr("name"),
        "time_out": time:now() }
    }
  }
  rule timing_finished {
    select when timing finished number re#n0*(\d+)#i setting(ordinal_string)
    pre {
      key = "N" + ordinal_string
    }
    if ent:timings >< key then noop()
    fired {
      ent:timings{[key,"time_in"]} := time:now()
    }
  }
  rule initialize_ruleset {
    select when wrangler ruleset_installed
      where event:attr("rids") >< meta:rid
    wrangler:createChannel(tags,eventPolicy,queryPolicy)
  }
}
