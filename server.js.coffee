# Defaults and hooligans
amqp_url = 'amqp://localhost'

# Load some shit up
db = require './database.js.coffee'
youtube = require 'youtube-feeds'
context = require('rabbit.js').createContext(amqp_url)

# This gives us the youtube url and puts in in the track
youtubizeThisTrack = (track) ->
  youtube.feeds.videos
    q: track.title + " " + track.artist
    'max-results':  1
    ,
    (err, result) ->
      video = result.items[0]
      track.uri = "http://www.youtube.com/watch?v=" + video.id
      track.save()


# Connect and listen to rabbitMQ, 
# trigger the resolution when we get a track ID as instruction
context = require('rabbit.js').createContext(amqp_url)
pull = context.socket('PULL')
pull.connect('youtube-resolves')
pull.setEncoding('utf8')
pull.on 'data', (id) ->
  track = db.Track.find id
  youtubeizeThisTrack track