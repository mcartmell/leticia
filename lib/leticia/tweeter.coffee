api = require 'node-twitter-api'
CONFIG = require('config').twitter

Tweeter =
  token: CONFIG.token
  secret: CONFIG.secret
  twitter: new api
    consumerKey: CONFIG.consumer_key
    consumerSecret: CONFIG.consumer_secret
  tweet: (msg) ->
    @twitter.statuses 'update', { status: msg }, @token, @secret, -> (err, data, response) ->
      if err
        console.log err
module.exports = Tweeter
