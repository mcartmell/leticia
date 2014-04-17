class Plugin
  finish: (arr) ->
    plg = this
    @guardCondition arr, ->
      for item in arr
        do (item) ->
          plg.callback(item)
  setCallback: (fn) ->
    @callback = fn
  guardCondition: (arr, fn) ->
    fn()
  runWithCallback: (fn, guard) ->
    if guard
      @guardCondition = guard
    @setCallback(fn)
    @run()
module.exports = Plugin
