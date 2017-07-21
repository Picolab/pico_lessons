ruleset child_subscriptions {
  meta {
    name "child_subscriptions"
    description <<
Demonstrate subscriptions between two children
>>
    author "PJW"

    use module Subscriptions alias wrangler

    provides subs
  }

  global {

    subs = function() {
       subs = wrangler:subscriptions(null, "name_space", "Closet");
       subs{"subscriptions"}
    }

  }

  rule introduce_myself {
    select when pico_systems introduction_requested

    pre {
      sub_attrs = {
        "name": event:attr("name"),
	"name_space": "Closet",
	"my_role": event:attr("my_role"),
	"subscriber_role": event:attr("subscriber_role"),
	"subscriber_eci": event:attr("subscriber_eci")
      }
      condition = not sub_attrs{"name"}.isnull()
        && not sub_attrs{"subscriber_eci"}.isnull()
      _ = condition => "".klog("subscription introduction made")
        | sub_attr.encode().klog("missing required attributes")
    }
    if condition then
       send_directive("subscription_introduction_sent", sub_attrs)
    fired {
      raise wrangler event "subscription" attributes sub_attrs
    }  
  }

  rule approve_subscription {
      select when pico_systems subscription_approval_requested
      pre {
        pending_sub_name = event:attr("sub_name")
	condition = not pending_sub_name.isnull()
	_ = condition => pending_sub_name.klog("Approving subscription")
	  | "".klog("No subscription name provided")
      }
      if condition then
         send_directive("subscription_approved",
	   {"pending_sub_name" : pending_sub_name})
     fired {
       raise wrangler event "pending_subscription_approval"
             attributes {"channel_name" : pending_sub_name}
     }
  }

  rule remove_subscription {
      select when pico_systems subscription_deletion_requested
      pre {
        pending_sub_name = event:attr("sub_name")
	condition = not pending_sub_name.isnull()
	_ = condition => pending_sub_name.klog("Approving subscription")
	  | "".klog("No subscription name provided")
      }
      if condition then
         send_directive("subscription_approved",
           {"pending_sub_name" : pending_sub_name})
     fired {
       raise wrangler event "subscription_cancellation"
             attributes {"channel_name" : pending_sub_name}
     }
  }

}
