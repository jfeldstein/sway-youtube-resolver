Sequelize = require("sequelize")

sequelize = new Sequelize "sway", "root", null,
  dialect: 'sqlite'
  sync: { force: true }
  underscored: true


Track = sequelize.define 'Track', 
  archived: 
    type: Sequelize.BOOLEAN
    default: false
  title: Sequelize.TEXT
  artist: Sequelize.TEXT
  uri: Sequelize.TEXT
  

module.exports.sequelize = sequelize
module.exports.Track = Track
