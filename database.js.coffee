Sequelize = require("sequelize")

if process.env.HEROKU_POSTGRESQL_ONYX_URL
  # the application is executed on Heroku ... use the postgres database
  match = process.env.HEROKU_POSTGRESQL_ONYX_URL.match(/postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/)

  sequelize = new Sequelize match[5], match[1], match[2], 
    dialect:  'postgres'
    protocol: 'postgres'
    port:     match[4]
    host:     match[3]
    logging:  true #false
    define:
      underscored: true
else
  # the application is executed on the local machine ... use mysql
  sequelize = new Sequelize "sway", "root", null,
    # Needs to point to your rails's development db, as configed in ../sway-backend/config/database.yml 
    # Also expects that rails is at ../sway-backend/
    storage: '../sway-backend/db/development.sqlite3'
    dialect: 'sqlite'
    #sync: { force: true }
    underscored: true
    define:
      underscored: true


Track = sequelize.define 'track', 
  archived: 
    type: Sequelize.BOOLEAN
    default: false
  title: Sequelize.TEXT
  artist: Sequelize.TEXT
  uri: Sequelize.TEXT
  

module.exports.sequelize = sequelize
module.exports.Track = Track
