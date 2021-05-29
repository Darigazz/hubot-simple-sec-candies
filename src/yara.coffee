# Description:
#   Generate very simple Yara rule. Needs modifications after creation
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot yara [RULENAME] [CATEGORY] [CONDITION] [COMMA SEPARATED IOCs] - Generates simple Yara rule.
#
# Author:
#   Igor Antunes - @Darigazz1984

get_date = () ->
   t = new Date
   day = t.getDate()
   month = t.getMonth()+1
   year = t.getFullYear()
   day = if day < 10 then '0' + day else day
   month = if month < 10 then '0' + month else month
   final = day + '-' + month + '-' + year


module.exports = (robot) ->
  robot.respond /yara (.*) (.*) (.*) (.*)/i, (res) ->
    rule_name = res.match[1]
    category = res.match[2]
    condtype = res.match[3]
    signatures = res.match[4].split ","
    
    
    date = get_date()

    i = 1
    sig = ""
    cond = ""
    for v in signatures
        sig += "  $#{i} = '#{v}'\n"
        cond += if i < signatures.length then "$#{i} #{condtype} " else "$#{i}"
        i++

    rule = """
    rule #{rule_name} : #{category}
    {
      meta:
        author = '[INSERT YOUR NAME HERE]'
        date = '#{date}'
        description = '[INSERT RULE DESCRIPTION HERE]'
      strings:
        #{sig}
    condition:
        #{cond}
    }
    """
    res.send rule
