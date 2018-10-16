require "sinatra"
require "erb"
require "pry"
require "socket"
require "doc_integrity_check"
require "curb"

# Set key to encrypt to
ENV['gpg_recipient'] = "6D2BA2ED"
ENV['gpg_signer'] = "6D2BA2ED"

# Set URLs to other apps
ENV['lookingglass_url'] = "http://localhost:3001"
ENV['ocrserver_url'] = "http://localhost:9393"

# Load all files
Dir.glob('./app/{send,controllers}/*.rb').each { |file| require file }

run UploadController
