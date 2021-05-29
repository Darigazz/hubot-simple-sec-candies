# Description:
#   Get Website Report from Google Safebrowsing (https://developers.google.com/safe-browsing)
#
# Dependencies:
#   None
#
# Configuration:
#   GOOGLE_SAFEBROWSING_API_KEY - Sign up at https://developers.google.com/safe-browsing/key_signup
#
# Commands:
#   hubot gsafe <url> - Gets Google Safebrowsing Report for URL
#
# Author:
#   A. Gianotto - @snipe
#   Updated by Igor Antunes - @Darigazz1984 

GOOGLE_SAFEBROWSING_API_KEY = process.env.GOOGLE_SAFEBROWSING_API_KEY


is_empty = (obj) ->
    return true if not obj? or obj.length is 0

    return false if obj.length? and obj.length > 0

    for key of obj
        return false if Object.prototype.hasOwnProperty.call(obj,key) 

    return true


module.exports = (robot) ->
  robot.respond /gsafe (.*)/i, (msg) ->

    if GOOGLE_SAFEBROWSING_API_KEY?
      gsafe_term = msg.match[1].toLowerCase()
      request_body = JSON.stringify({client:{clientId:'home',clientVersion:'0.1'},threatInfo:{threatTypes:['MALWARE','SOCIAL_ENGINEERING','UNWANTED_SOFTWARE'],platformTypes:['ALL_PLATFORMS'],threatEntryTypes:['URL'],threatEntries:[{url:gsafe_term}]}})
    
      api_url = "https://safebrowsing.googleapis.com/v4/threatMatches:find"
      request_url = api_url
      request_url += "?key=#{GOOGLE_SAFEBROWSING_API_KEY}"

      robot.http(request_url)
        .header('Content-Type','application/json')
        .post(request_body) (err, res, body) ->
          d = JSON.parse(body)
          if res.statusCode is 200
            if is_empty(d)
              msg.send "[CLEAN] The URL #{gsafe_term} is NOT curently listed as suspicious in Google Safebrowsing. More info: at http://www.google.com/safebrowsing/diagnostic?site=#{encodeURIComponent gsafe_term}"
            else
               msg.send "[SUSPICIOUS] The URL #{gsafe_term} is listed as Malicious in Google Safebrowsing. More info: at http://www.google.com/safebrowsing/diagnostic?site=#{encodeURIComponent gsafe_term}"
          else
            msg.send "[ERROR] Got a #{res.statusCode} instead of a 200."

    else
    	msg.send "API Key not configured"
