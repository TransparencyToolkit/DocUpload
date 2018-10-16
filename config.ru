require "sinatra"
require "erb"
require "pry"
require "socket"
require "doc_integrity_check"
require "curb"

# Set key to encrypt to
ENV['gpg_recipient'] = "6684E718" if ENV['gpg_recipient'] == nil
ENV['gpg_signer'] = "6684E718" if ENV['gpg_signer'] == nil

# Set URLs to other apps
ENV['lookingglass_url'] = "http://localhost:3001" if ENV['lookingglass_url'] == nil
ENV['ocrserver_url'] = "http://localhost:9393" if ENV['ocrserver_url'] == nil

# Load all files
Dir.glob('./app/{send,controllers}/*.rb').each { |file| require file }

run UploadController
