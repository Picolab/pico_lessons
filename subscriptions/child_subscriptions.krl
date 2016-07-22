ruleset child_subscriptions {
  meta {
    name "child_subscriptions"
    description <<
Demonstrate subscriptions between two children
>>
    author "PJW"

    use module v1_wrangler alias wrangler
    sharing on

    provides subs
  }

  global {

    subs = function() {
       subs = wrangler:subscriptions(null, "name_space", "Closet");
       subs{"subscriptions"}
    }

  }
  
}