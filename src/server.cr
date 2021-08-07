require "kemal"
require "./handlers/handler.cr"
require "./views/*"


module Server
  VERSION = "0.1.0"
  port = 5010

  Kemal.run port 
end