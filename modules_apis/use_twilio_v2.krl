ruleset io.picolabs.use_twilio_v2 {
  meta {
    name "io.picolabs.use_twilio_v2"
    description <<
Uses the module io.picolabs.twilio_v2 to show how module configuration and keys work
>>
    author "Phil Windley"

    use module io.picolabs.lesson_keys 

    use module io.picolabs.twilio_v2 alias twilio
        with account_sid = keys:twilio("account_sid")
             auth_token =  keys:twilio("auth_token")

  }

  rule test_send_sms {
    select when test new_message
    pre {
      my_sid = keys:twilio("account_sid").klog("SID: ")
    }
    twilio:send_sms(event:attr("to"),
                    event:attr("from"),
                    event:attr("message")
                   )
  }

}