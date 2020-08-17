ruleset event_attrs {
  rule type1 {
    select when attrs type1
    pre {
      bound_attr = event:attr("the_attr")
    }
    send_directive("the_attr",{"bound_attr": bound_attr})
  }

  rule type4 {
    select when attrs type4
    pre {
      bound_attr = event:attrs{"the_attr"}
    }
    send_directive("the_attr",{"bound_attr": bound_attr})
  }

  rule type3 {
    select when attrs type3 the_attr re#(.*)# setting(bound_attr)
    send_directive("the_attr",{"bound_attr": bound_attr})
  }

  rule type2 {
    select when attrs type2
    pre {
      bound_attr = event:attrs.get("the_attr")
    }
    send_directive("the_attr",{"bound_attr": bound_attr})
  }
}
