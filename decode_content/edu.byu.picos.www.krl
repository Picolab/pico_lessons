ruleset edu.byu.picos.www {
  meta {
    shares __testing, decode_content
  }
  global {
    __testing = { "queries": [ { "name": "__testing" },
                               { "name": "decode_content", "args": [ "content" ] } ],
                  "events": [ ] }
    o0 = "0".ord();
    oa = "a".ord();
    hexDigit2dec = function(h){ // character -> number in [0,15]
      o = h.lc().ord();
      h like re#^[0-9A-Fa-f]$# => (o < oa => o - o0 | o - oa + 10)
                              | 0
    }
    hex2dec = function(hex) { // string len k -> number in [0,16^k-1] or null
      hex like re#^[0-9A-Fa-f]*$#
        => hex.split("")
              .map(function(h){hexDigit2dec(h)})
              .reduce(function(a,h){a*16+h},0)
         | null
    }
    hex2char = function(coded,hex) { // string len 2 -> character or %string
      val = hex2dec(hex.klog("hex"));
      hex.length() == 2 && val && val < 128
        => (val.klog("val")).chr()
         | coded
    }
    decode_val = function(s) {
      s.replace(re#[+]#g," ")
       .replace(re#%(..)#g,hex2char)
    }
    dup_1st = function(v){ decode_val(v[0][1]) }
    dup_all = function(v){
      v.length() == 1 => decode_val(v[0][1])
                       | v.map(function(w){decode_val(w[1])})
    }
    nv_split = function(x){x.extract(re#([^=]*)=?(.*)#)}
    frst = function(a){a.head()}
    decode_content = function(content) {
      content        //"n0=v0&n1=v1&...nk=vk"
      .split(re#&#)  //["n0=v0","n1=v1",..."nk=vk"]
      .map(nv_split) //[["n0","v0"],["n1","v1"],...["nk","vk"]]
      .collect(frst) //{"n0":[["n0","v0"]],"n1":[["n1","v1"]],..."nk":[["nk","vk"]]}
      .map(dup_1st)  //{"n0":"v0","n1":"v1",..."nk":"v1"}
    }
  }
}
