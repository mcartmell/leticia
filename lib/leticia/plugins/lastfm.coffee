Plugin = require '../plugin'
CONFIG = require('config').plugins.lastfm
class LastFM extends Plugin
  constructor: ->
    api = require('lastfmapi')
    @lfm = new api
      api_key: CONFIG.api_key
      secret: CONFIG.secret
    @lfm.setSessionCredentials CONFIG.session_user, CONFIG.session_key
  getLatestEvents: ->
    events = @lfm.geo.getEvents 
      location: 'Singapore'
    , (err, events) => 
      if err
        console.log 'Error running plugin: ' + err
      else
        first_event = events.event[0]
        title = first_event.title
        venue = first_event.venue.name
        msg = title + ' at ' + venue
        @finish([msg])
  run: ->
    @getLatestEvents()
  getSchedule: ->
    '0 */10 * * * *'
module.exports = LastFM
