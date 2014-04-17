Plugin = require '../plugin'
CONFIG = require('config').plugins.movies
request = require 'request'
cheerio = require 'cheerio'
async = require 'async'
imdb = require 'imdb-api'
_ = require 'underscore'

lookupRating = (item, cb) ->
  imdb.getReq {name: item}, (err, things) ->
    console.log err
    console.log things
    cb(err, [item, parseFloat(things.rating)])

processResults = (cb) ->
  (err, results) ->
    best = _.max results, (movie) ->
      movie[1]
    best_name = best[0]
    msg = 'The best movie at the moment is ' + best_name
    console.log msg
    cb(msg)

class Movies extends Plugin
  plg = this
  getBestMovie: ->
    request CONFIG.url, (err, res, body) ->
      $ = cheerio.load body
      names = []
      $('.movie .name').each (i, elem) ->
        str = $(elem).text()
        unless str.match '3D'
          names.push str
      async.mapSeries names, lookupRating, processResults (msg) ->
        plg.finish([msg])
  run:  ->
    console.log 'running movies'
    @getBestMovie()
  getSchedule: ->
    '*/5 * * * * *'
module.exports = Movies
