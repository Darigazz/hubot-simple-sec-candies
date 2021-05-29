# Description:
#   Search AbuseIPDB
#
# Dependencies:
#   None
#
# Configuration:
#    ABUSEIPDB_API_KEY - Sign up at https://www.abuseipdb.com
#
# Commands:
#   hubot abuse <IP> - Search AbuseIPDB for any information about the IP
#
# Author:
#   Updated by Igor Antunes - @Darigazz1984

ABUSEIPDB_API_KEY = process.env.ABUSEIPDB_API_KEY

api_url = "https://api.abuseipdb.com/api/v2/"

module.exports = (robot) ->
  robot.respond /abuse\s(\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b|([0-9a-f]{1,4}|::)((:{0,2}[0-9a-f]{0,4}){0,7}))$/i, (msg) ->

    if ABUSEIPDB_API_KEY?
      ip = msg.match[1].toLowerCase()

      request_url = api_url + "check?ipAddress=#{ip}"

      robot.http(request_url)
        .headers(
          'Key': ABUSEIPDB_API_KEY, 
          'Accept': 'application/json')
        .get() (err, res, body) ->
          
          if res.statusCode is 200
            d = JSON.parse(body)
            result = """
              Results for IP #{ip}
              Abuse Confidence = #{d.data.abuseConfidenceScore}%
              Number of Reports = #{d.data.totalReports}
              Country Code = #{d.data.countryCode}
              ISP = #{d.data.isp}
              Usage Type = #{d.data.usageType}
              In Whitelist = #{d.data.isWhitelisted}

            """
            msg.send result
          else
            msg.send "Error retriving information for IP: #{ip}"

          

    else
        msg.send "AbuseIPDB API key not configured"