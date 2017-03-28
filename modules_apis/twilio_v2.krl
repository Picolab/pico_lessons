ruleset io.picolabs.twilio_v2 {
  meta {
    name "Twilio SMS Module for Pico Lessons"
    description <<
      Twilio SMS

      v2 - uses config to get keys

    >>
    author "Phil Windley"
    logging on

    configure using account_sid = ""
                    auth_token = ""
    
    provides 
        //actions
        send_sms
  }

  global {
    
    send_sms = defaction(to, from, message) {
       base_url = "https://" + twiliokeys{"account_sid"} + ":" + twiliokeys{"auth_token"} +
                      "@api.twilio.com/2010-04-01/Accounts/" + twiliokeys{"account_sid"} + "/"
       http:post(base_url + "Messages.json")
            with body = {
                "From":from,
                "To":to,
                "Body":message
            }
    }
  }
    
}
