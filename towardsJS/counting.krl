ruleset counting {
  meta {
    shares __testing, count, largeCounts, countersAt, totalCount
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "count", "args": [ "name" ] }
      , { "name": "largeCounts", "args": [ "limit" ] }
      , { "name": "countersAt", "args": [ "value" ] }
      , { "name": "totalCount" }
      ] , "events":
      [ { "domain": "counting", "type": "needed", "attrs": [ "name" ] }
      , { "domain": "counting", "type": "one_more", "attrs": [ "name" ] }
      , { "domain": "counting", "type": "new_value", "attrs": [ "name", "value" ] }
      , { "domain": "counting", "type": "needs_reset", "attrs": [ "name" ] }
      , { "domain": "counting", "type": "not_needed", "attrs": [ "name" ] }
      ]
    }
    count = function(name){
      ent:counts{name}
    }
    largeCounts = function(limit){
      threshold = limit || 0;
      ent:counts.filter(function(c,n){c>threshold})
    }
    countersAt = function(value){
      target = value.as("Number");
      ent:counts.filter(function(c,n){c==target}).keys()
    }
    totalCount = function(){
      ent:counts.values().reduce(function(a,n){a+n})
    }
  }
  rule initialize {
    select when wrangler ruleset_added where event:attr("rids") >< meta:rid
    if ent:counts.isnull() then noop();
    fired{
      ent:counts := {};
    }
  }
  rule create_counter {
    select when counting needed name re#^(.+)$# setting(name)
    if not (ent:counts.keys() >< name) then noop();
    fired{
      ent:counts{name} := 0;
    }
  }
  rule increment_count {
    select when counting one_more name re#^(.+)$# setting(name)
    pre{
      old_count = ent:counts{name}.defaultsTo(0);
      new_count = old_count + 1;
    }
    fired{
      ent:counts{name} := new_count;
    }
  }
  rule set_counter {
    select when counting new_value
      name re#^(.+)$#
      value re#^(\d+)$# setting(name,value)
    fired{
      ent:counts{name} := value.as("Number");
    }
  }
  rule reset_counter {
    select when counting needs_reset name re#^(.+)$# setting(name)
    fired{
      ent:counts{name} := 0;
    }
  }
  rule remove_counter {
    select when counting not_needed name re#^(.+)$# setting(name)
    fired{
      clear ent:counts{name}
    }
  }
}
