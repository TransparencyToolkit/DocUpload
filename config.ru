require "sinatra/base"
require "erb"
require "pry"
require "socket"
require "doc_integrity_check"

# Set key to encrypt to
ENV['gpg_recipient'] = "3752BE4E"

# Set LookingGlass URL
ENV['lookingglass_url'] = "http://localhost:3001"

# Load all files
Dir.glob('./app/{udp,controllers}/*.rb').each { |file| require file }

run UploadController

