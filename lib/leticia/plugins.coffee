CronJob = require('cron').CronJob
CONFIG = require('config').twitter

redis = require 'redis'
client = redis.createClient()

# passed the data to check, and a callback to run only if the data is fresh
checkFreshness = (arr, cb) ->
  cache_key = 'leticia-' + @name + '-last'
  json = JSON.stringify(arr)
  console.log 'running ' + @name + '!'
  client.get cache_key, (err, reply) ->
    unless reply == json
      # ok to run callback
      cb()
      client.set cache_key, json

Plugins = 
  msgCallback: (msg) ->
    console.log 'got ' + msg
    @leticia.Tweeter.tweet('@' + CONFIG.username + ' ' + msg)
  registerPlugins: (leticia) ->
    @leticia = leticia
    plg = this
    require("fs").readdirSync("./lib/leticia/plugins").forEach (file) ->
      if file.match('swp')
        return
      plugin_class = require "./plugins/" + file
      plugin = new plugin_class
      base = file.replace '.coffee', '';
      plugin.name = base
      plg.schedulePlugin leticia, plugin
  runPlugin: (leticia, plugin) ->
    # return a callback
    => 
      plugin.runWithCallback @msgCallback.bind(this), checkFreshness
  schedulePlugin: (leticia, plugin) ->
    new CronJob(plugin.getSchedule(), this.runPlugin(leticia, plugin), null, true)
    console.log 'scheduled ' + plugin.name + '!'
module.exports = Plugins
