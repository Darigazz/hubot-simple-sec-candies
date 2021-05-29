# Description:
#   Geolocate an IP using ipgeolocation.io
#
# Dependencies:
#   None
#
# Configuration:
#   IPGEOLOCATION_API_KEY - Get an account at: https://ipgeolocation.io/
#
# Commands:
#   hubot geo <ip> - Gets location associated with an IP
#
# Author:
#   Igor Antunes - @darigazz1984

IPGEOLOCATION_API_KEY = process.env.IPGEOLOCATION_API_KEY

module.exports = (robot) ->
  robot.respond /geol (\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b|([0-9a-f]{1,4}|::)((:{0,2}[0-9a-f]{0,4}){0,7}))$/i, (msg) ->
    ip = msg.match[1]
    robot.http("https://api.ipgeolocation.io/ipgeo?apiKey=#{IPGEOLOCATION_API_KEY}&ip=#{ip}")
      .get() (err, res, body) ->
        if res.statusCode is 200
          ipinfo = JSON.parse body
          msg.send "-----------------------"
          msg.send "IP = #{ip}"
          msg.send "City = #{ipinfo['city']}"
          msg.send "State of Providence = #{ipinfo['state_prov']}"
          msg.send "Country = #{ipinfo['country_name']}"
          msg.send "ISP = #{ipinfo['isp']}"
          msg.send "-----------------------"
        else
          msg.send "Error: Couldn't locate the requested IP"
