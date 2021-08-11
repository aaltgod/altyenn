require "kemal"
require "./handlers/handler.cr"
require "./views/*"
require "db"
require "pg"
require "./repository/postgres/*"
require "./constants/constant.cr"


module Server
  VERSION = "0.1.0"
  DEBUG = false
  port = 5010
  
  db = Storage::Storage.new
  db.prepare

  Kemal.run port 
end