Plugin = require '../plugin'
request = require 'request'
moment = require 'moment'
_ = require 'underscore'
CONFIG = require('config').plugins.meetup
class Meetup extends Plugin
  url: ->
    'http://api.meetup.com/2/events/?member_id=' + CONFIG.user_id + '&key=' + CONFIG.api_key
  getEvents: ->
    request @url(), (err, res, body) ->
      if err
        throw err
      else
        json = JSON.parse body
        results = _.sortBy json.results, (event) ->
          event.time
        event = results[0]
        return unless event?
        time = event.time
        name = event.name
        group = event.group.name
        venue_name = event.venue.name
        url = event.event_url
        time = moment(time).calendar()
        msg = 'Next event: ' + group + ' - ' + name + ' at ' + venue_name + ' on ' + time + ' ' + url
        @finish([msg])
  run: ->
    @getEvents()
module.exports = Meetup
