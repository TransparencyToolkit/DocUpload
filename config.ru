require "sinatra/base"
require "erb"
require "pry"
require "socket"
require "doc_integrity_check"
require "curb"

# Set key to encrypt to
ENV['gpg_recipient'] = "6684E718"
ENV['gpg_signer'] = "6684E718"

# Set URLs to other apps
ENV['lookingglass_url'] = "http://localhost:3001"
ENV['ocrserver_url'] = "http://localhost:9393"

# Load all files
Dir.glob('./app/{send,controllers}/*.rb').each { |file| require file }

run UploadController

