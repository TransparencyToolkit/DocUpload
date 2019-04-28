require "sinatra"
require "erb"
require "pry"
require "socket"
require "curb"

# Set URLs to other apps
ENV['LOOKINGGLASS_URL'] = "http://localhost:3001" if ENV['LOOKINGGLASS_URL'] == nil
ENV['OCR_IN_PATH'] = "/home/user/ocr_in" if ENV['OCR_IN_PATH'] == nil
ENV['OCR_OUT_PATH'] = "/home/user/ocr_out" if ENV['OCR_OUT_PATH'] == nil
ENV['ARCHIVEADMIN_URL'] = "http://localhost:3002" if ENV['ARCHIVEADMIN_URL'] == nil
ENV['PUBLIC_ARCHIVEADMIN_URL'] = "http://localhost:3002" if ENV['PUBLIC_ARCHIVEADMIN_URL'] == nil

# Set project config info
ENV['PROJECT_INDEX'] = "archive_test_hcfgog" if ENV['PROJECT_INDEX'] == nil
ENV['ARCHIVE_SECRET_KEY'] = "UWSzDa2mcuRoFmmu3epvYOhcm8GMyLVDYH0cngi5bV3+90tQWUGZpSc2ghMYoiIpIabYit7zIcwg5UE3e2iU5nmLbB2lJfIP8NhTYmOe6PsbfM8VnDHk0cP1IRLgqYybJndiPw==" if ENV['ARCHIVE_SECRET_KEY'] == nil


# Load all files
Dir.glob('./app/{save,controllers}/*.rb').each { |file| require file }

run UploadController
