class UploadController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)
  include ProcessInput

  # Show the project form
  get "/upload/:project" do
    @project = params["project"]
    erb :upload
  end

  # Process uploaded file (and doc title and desc)
  post "/upload" do
    # Upload docs and metadata to OCR server
    parse_and_send_everything(params)

    # Redirect to success page
    redirect "/success?project=#{params["project"]}"
  end

  # Show a success message if it uploaded correctly
  get "/success" do
    @project = params["project"]
    erb :success
  end
end