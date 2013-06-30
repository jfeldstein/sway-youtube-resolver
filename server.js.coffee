# Defaults and hooligans
amqp_url = process.env.CLOUDAMQP_URL

# Load some shit up
db      = require './database.js.coffee'
Step    = require './lib/step.js'
youtube = require 'youtube-feeds'


# This gives us the youtube url and puts in in the track
youtubizeThisTrack = (track) ->
  #console.log "TRACK TO YOUTUBIZE", track
  youtube.feeds.videos
    q: track.title + " " + track.artist
    'max-results':  1
    ,
    (err, result) ->
      video = result.items[0]
      track.uri = "http://www.youtube.com/watch?v=" + video.id
      track.save()


console.log("ATTEMPTING TO RABBIT TO", amqp_url)
context = require('rabbit.js').createContext(amqp_url)
context.on 'ready', -> 
  console.log "RABBIT READY"
  pull = context.socket('PULL')
  pull.setEncoding('utf8')
  pull.connect 'youtube-resolves', ->
    console.log "RABBIT CONNECTED"
    pull.on 'data', (id) ->
      #console.log "GOT DATA", arguments
      db.Track.find(id).success (track) ->
        if track? then youtubizeThisTrack track else console.error("TRACK NOT FOUND", id)




