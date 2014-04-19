Plugin = require '../plugin'
CONFIG = require('config').plugins.weather
class Weather extends Plugin
  constructor: ->
    api = require('wundergroundnode')
    @wunder = new api(CONFIG.key)
  getWeather: ->
    @wunder.conditions().request CONFIG.location, (err, response) =>
        if err
          console.log 'Error running plugin: ' + err
        else
          weather = response.current_observation.weather
          msg = 'Current weather: ' + weather + '.'
          @finish([msg])
  run: ->
    @getWeather()
module.exports = Weather
