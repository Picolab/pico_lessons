ruleset io.picolabs.twilio_v1 {
  meta {
    name "Twilio SMS Module for Pico Lessons"
    description <<
      Twilio SMS

      v1 - keys as parameters to action

    >>
    author "Phil Windley"
    logging on
    
    provides 
        //actions
        send_sms
  }

  global {
    
    send_sms = defaction(to, from, message, account_sid, auth_token){
       base_url = "https://" + account_sid + ":" + auth_token + "@api.twilio.com/2010-04-01/Accounts/" + account_sid + "/"
       http:post("http://requestb.in/r7evu2r7") //base_url + "Messages.json")
            with body = {
                "From":from,
                "To":to,
                "Body":message
            }.klog("Body: ")
    }
  }

  rule test_send_sms {
    select when test new_message
    send_sms(event:attr("to"),
             event:attr("from"),
             event:attr("message"),
             event:attr("account_sid"),
             event:attr("auth_token"))
  }
    
}
