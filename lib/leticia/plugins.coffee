CronJob = require('cron').CronJob
CONFIG = require('config').twitter

redis = require 'redis'
client = redis.createClient()

# passed the data to check, and a callback to run only if the data is fresh
checkFreshness = (arr, cb) ->
  return unless arr? && arr.length > 0
  cache_key = 'leticia-' + @name + '-last'
  json = JSON.stringify(arr)
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
      base = file.replace '.coffee', '';
      try
        plugin = new plugin_class
        plugin.name = base
        plg.schedulePlugin leticia, plugin
      catch error
        console.log 'failed to load ' + base + ', disabling'
  runPlugin: (leticia, plugin) ->
    # return a callback
    => 
      console.log 'running ' + plugin.name
      try
        plugin.runWithCallback @msgCallback.bind(this), checkFreshness
      catch e
        console.log 'error: ' + e
  schedulePlugin: (leticia, plugin) ->
    unless plugin.getConfig()
      console.log 'skipping ' + plugin.name
      return
    sched = plugin.getSchedule()
    new CronJob(sched, this.runPlugin(leticia, plugin), null, true)
    console.log 'scheduled ' + plugin.name + ' (' + sched + ')!'
module.exports = Plugins
