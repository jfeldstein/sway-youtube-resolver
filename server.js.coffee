# Load some shit up
db = require './database.js.coffee'
youtube = require 'youtube-feeds'

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

# Crush and recreate the database cause we're destructive as fuck
console.log "about to dominate"
db.sequelize.sync().done ->
  # Fuck me it's a track we'll scan for
  console.log "Lookin for the tracksalot"
  db.Track.findOrCreate(
    artist: "The Malah"
    title: "Yorokobu"
    # Scan for it on success
  ).success youtubizeThisTrack
