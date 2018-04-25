ruleset io.picolabs.root {
  meta {
    description <<experimental root ruleset>>
    use module io.picolabs.wrangler alias wrangler
    shares __testing, what
  }
  global {
    __testing = { "queries": [ { "name": "__testing" },
                               { "name": "what" } ],
                  "events": [ ] }
    users = function() {
      skyPre = meta:host + "/sky/cloud/";
      skyPost = "/io.picolabs.visual_params/dname";
      wrangler:children()
        .collect(function(v){
            dname = http:get(skyPre+v{"eci"}+skyPost){"content"}.decode();
            dname.typeof()=="String" => dname | ""
          })
        .filter(function(v,k){k like re#Mischief|Thing \d+#})
        .map(function(v){v[0]{"id"}})
    }
    option = function(v,k) {
      <<<option value="#{v}">#{k}</option>
>>
    }
    select = function(optionsMap) {
      main = option("","please select");
      opts = optionsMap.map(option).values().join("");
      <<<select>
#{main}#{opts}</select>
>>
    }
    what = function() {
      select(users())
    }
  }
}
