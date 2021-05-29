# hubot-simple-sec-candies

Simple scripts to gather rudimentary information

## This is an updated code to https://github.com/sroberts/hubot-vtr-scripts
I take only credit for updating the code and adding the AbusdeIPDB script, the Yara which was almost fully redone and the geolocation which was fully redone to use ipgeolocation.io

## Installation

In hubot project repo, run:

`npm install hubot-simple-sec-candies --save`

Then add **hubot-simple-sec-candies** to your `external-scripts.json`:

```json
[
  "hubot-simple-sec-candies"
]
```

## Configuration
In order to run this successfully you will need to configure a set of API Keys to access the external services.
The API Keys are configured as environment variables. Check the example bellow.

```
export SHODAN_API_KEY=
export VIRUSTOTAL_API_KEY=
export GOOGLE_SAFEBROWSING_API_KEY=
export IPGEOLOCATION_API_KEY=
export ABUSEIPDB_API_KEY=
```

## Sample Interaction

```
user1>> hubot shodan 1.1.1.1
hubot>> Shodan Result for 1.1.1.1
- Geo: Westport, undefined, United States
- Last Update: 2021-05-29T17:30:02.520041
- Hostname: one.one.one.one
- OS: null
- Organization: APNIC and Cloudflare DNS Resolver project
- ISP: Cloudflare, Inc.
- ASN: AS13335
- Domains: one.one
- Ports: 53
```

## NPM Module

https://www.npmjs.com/package/hubot-simple-sec-candies
