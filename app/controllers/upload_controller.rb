class UploadController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.dirname(__FILE__) + '/../../public'
  include ProcessInput

  # Control access
  before do
    # Check with account system to verify access
    archive_admin_cookie = request.cookies["archive_auth_key"]
    http = Curl.post("#{ENV['ARCHIVEADMIN_URL']}/can_access_archive", {archive_auth_key: archive_admin_cookie,
                                                                       archive_secret_key: ENV['ARCHIVE_SECRET_KEY'],
                                                                       index_name: ENV['PROJECT_INDEX']})
    has_access = JSON.parse(http.body_str)["has_access"]

    # Redirect if doesn't hace access
    if has_access == "unauthenticated"
      redirect "#{ENV['PUBLIC_ARCHIVEADMIN_URL']}/unauthenticated"
    elsif has_access == "no"
      redirect "#{ENV['PUBLIC_ARCHIVEADMIN_URL']}/not_allowed"
    end
  end

  # Show the project form
  get "/" do
    @project = ENV['PROJECT_INDEX']
    erb :upload
  end

  # Process uploaded file (and doc title and desc)
  post "/" do
    # Upload docs and metadata to OCR server
    parse_and_save_everything(params, ENV['PROJECT_INDEX'])

    # Redirect to success page
    redirect "#{ENV['RAILS_RELATIVE_URL_ROOT']}success"
  end

  # Show a success message if it uploaded correctly
  get "#{ENV['RAILS_RELATIVE_URL_ROOT']}success" do
    content_type :json
    {status: "success", message: "File has been successfully uploaded"}.to_json
  end
end
