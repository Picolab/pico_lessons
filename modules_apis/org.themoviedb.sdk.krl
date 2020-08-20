ruleset org.themoviedb.sdk {
  meta {
    version "0.0.0"
    name "themoviedb SDK"
    author "Pico Labs"
    description <<
      An SDK for themoviedb
    >>
    configure using
      apiKey = ""
      sessionID = ""
    provides getPopular, rateMovie
  }
  global {
    base_url = "https://api.themoviedb.org/3"

    getPopular = function() {
      queryString = {"api_key":apiKey}
      response = http:get(<<#{base_url}/movie/popular>>, qs=queryString)
      response{"content"}.decode()
    }

    rateMovie = defaction(movieID, rating) {
      queryString = {"api_key":apiKey,"session_id":sessionID}
        .klog("qs")
      body = {"value":rating}
        .klog("json")
      http:post(<<#{base_url}/movie/${movieID}/rating>>
        .klog("url")
        ,qs=queryString,json=body) setting(response)
      return response
    }
  }
}
