# Leticia

A friendly ~~domestic~~ internet helper.

# Description

A pluggable node.js loop that monitors various internet services and delivers
notifications when they change. Inspired by
[Huginn](https://github.com/cantino/huginn) and the like.

Currently, it only support notifications via Twitter.

Supported plugins so far are:

* Google Movies: Checks a local cinema listing and tells you the top films currently showing, ordered by IMDB score.
* Weather: Gets the latest weather conditions from Wunderground
* LastFM: Tells you the next gig for a given location
* Meetup: Tells you the next Meetup event for groups that you're a member of

# Running

You'll need to `cp config/default.yaml.example config/default.yaml` and fill in the API keys for the various services. Then just run `coffee leticia.coffee`.

# Plugins

Every plugin must have a corresponding section in the config, if you want to
use it. Each plugin has different config options; see the example file for
details. The only option common to every plugin is `schedule`, which must be a
string in `cron` format describing when the plugin should run.

See below for specific config examples

## LastFM

Config:

```yaml
plugins:
  lastfm:
    api_key: ''
    secret: ''
    session_user: 'your_username'
    session_key: ''
    schedule: '0 0 9 * * *'
    location: 'Singapore'
```

See [this gist](https://gist.github.com/klange/958285) for how to create a session key.

The location is straightforward; it will use this location to find events.

## Weather

Config:

```yaml
plugins:
  weather:
    key: ''
    location: 'SG/Singapore'
    schedule: '0 */10 * * * *'
```

Just set the `location` and your API key. See [http://www.wunderground.com/weather/api/](http://www.wunderground.com/weather/api/) for more details.

## Movies

Config:

```yaml
plugins:
  movies:
    url: 'http://www.google.com.sg/movies?near=serangoon&tid=fb8ae472ecc03387'
    schedule: '0 0 8 * * *'
```

Set `url` to the google movies URL of your local cinema.

## Meetup

```yaml
plugins:
  meetup:
    api_key: ''
    user_id: 'your userid'
```

Just fill in your user id and API key. It will fetch the events from the groups you've joined.

## Twitter notifications

```yaml
twitter:
  consumer_key: ''
  consumer_secret: ''
  token: ''
  secret: ''
  username: 'your_username'
```

Fill in all the API keys, once you've persuaded twitter's backend to actually
give them to you. Your twitter app must have write access.

Note this goes at the top level of the config, not under `plugins`.

# What next?

I've run out of ideas for plugins. Feel free to add more!

# Why 'Leticia'?

Leticia is a [celebrity maid](http://www.youtube.com/watch?v=yrZwVdjRJiw).
