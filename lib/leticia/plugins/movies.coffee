Plugin = require '../plugin'
CONFIG = require('config').plugins.movies
request = require 'request'
cheerio = require 'cheerio'
async = require 'async'
imdb = require 'imdb-api'
_ = require 'underscore'

lookupRating = (item, cb) ->
  imdb.getReq {name: item}, (err, things) ->
    cb(err, [item, parseFloat(things.rating)])

processResults = (cb) ->
  (err, results) ->
    # find top 3 movies as rated by IMDB
    best = _.sortBy results, (movie) ->
      movie[1]
    .map (m) ->
      m[0]
    .reverse().slice(0,3).sort()
    msg = best.join(', ')
    msg = 'Top movies: ' + msg
    cb(msg)

class Movies extends Plugin
  getBestMovie: ->
    plg = this
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
    @getBestMovie()
module.exports = Movies
