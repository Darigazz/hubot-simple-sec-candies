# Description:
#   Search Shodan based on https://developers.shodan.io/shodan-rest.html
#
# Dependencies:
#   None
#
# Configuration:
#   SHODAN_API_KEY - Sign up at http://www.shodanhq.com/api_doc
#
# Commands:
#   hubot shodan <IP> - Search Shodan for any information about the IP
#   hubot shodan-full <IP> - Search Shodan for any information about the IP but with full details
#
# Author:
#   Scott J Roberts - @sroberts
#   Updated by Igor Antunes - @darigazz1984

SHODAN_API_KEY = process.env.SHODAN_API_KEY

api_url = "https://api.shodan.io"

module.exports = (robot) ->
  robot.respond /shodan\s(.*)/i, (msg) ->

    if SHODAN_API_KEY?
      shodan_term = msg.match[1].toLowerCase()

      request_url = api_url + "/shodan/host/#{shodan_term}?key=#{SHODAN_API_KEY}"

      robot.http(request_url)
        .get() (err, res, body) ->

          if res.statusCode is 200
            shodan_json = JSON.parse body

            if shodan_json.error
              shodan_profile = "No Shodan information found for #{shodan_term}"

            else

              shodan_profile = """Shodan Result for #{shodan_term}
              - Geo: #{shodan_json.city}, #{shodan_json.region_name}, #{shodan_json.country_name}
              - Last Update: #{shodan_json.last_update}
              - Hostname: #{shodan_json.hostnames.toString()}
              - OS: #{shodan_json.os}
              - Organization: #{shodan_json.org}
              - ISP: #{shodan_json.isp}
              - ASN: #{shodan_json.asn}
              - Domains: #{shodan_json.domains.toString()}
              - Ports: #{shodan_json.ports.toString()}
              """
              msg.send shodan_profile
          else
            msg.send "Sorry dude couldn't get the requested IP. Received this status code: #{res.statusCode}"

    else
        msg.send "Shodan API key not configured. Get one at http://www.shodanhq.com/api_doc"

  robot.respond /shodan-full (.*)/i, (msg) ->

    if SHODAN_API_KEY?
      shodan_term = msg.match[1].toLowerCase()

      request_url = api_url + "/shodan/host/#{shodan_term}?key=#{SHODAN_API_KEY}"

      robot.http(request_url)
        .get() (err, res, body) ->

          if res.statusCode is 200
            shodan_json = JSON.parse body

            if shodan_json.error
              shodan_profile = "No Shodan information found for #{shodan_term}"

            else

              shodan_profile = """Shodan Result for #{shodan_term}
              - Geo: #{shodan_json.city}, #{shodan_json.region_name}, #{shodan_json.country_name}
              - Last Update: #{shodan_json.last_update}
              - Hostname: #{shodan_json.hostnames.toString()}
              - OS: #{shodan_json.os}
              - Organization: #{shodan_json.org}
              - ISP: #{shodan_json.isp}
              - ASN: #{shodan_json.asn}
              - Domains: #{shodan_json.domains.toString()}
              - Ports: #{shodan_json.ports.toString()}
              --------------------------------------------
              """

              for host in shodan_json.data
               shodan_profile += "\n- Version: #{host.version}\n"
               shodan_profile += "- OS: #{host.os}\n"
               shodan_profile += "- Port: #{host.port}\n"
               shodan_profile += "- Protocol: #{host.transport}\n"
               shodan_profile += "- Product: #{host.product}\n"
               shodan_profile += "- Full data: #{host.data}\n"
               shodan_profile += "--------------------------------------------\n"
              msg.send shodan_profile
          else
            msg.send "Sorry dude couldn't get the requested IP. Received this status code: #{res.statusCode}"

    else
        msg.send "Shodan API key not configured. Get one at http://www.shodanhq.com/api_doc"
