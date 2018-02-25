require "sinatra/base"
require "erb"
require "pry"
require "socket"
require "doc_integrity_check"

# Set key to encrypt to
ENV['gpg_recipient'] = "3752BE4E"

# Load all files
Dir.glob('./app/{processors,controllers}/*.rb').each { |file| require file }

run UploadController

