class UploadController < Sinatra::Base
  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.dirname(__FILE__) + '/../../public'
  include ProcessInput

  # Show the project form
  get "/upload/:project/:doc_type" do
    @project = params["project"]
    @doc_type = params["doc_type"]
    erb :upload
  end

  # Process uploaded file (and doc title and desc)
  post "/upload" do
    # Upload docs and metadata to OCR server
    parse_and_send_everything(params)

    # Redirect to success page
    redirect "/success?project=#{params["project"]}&doc_type=#{params["doc_type"]}"
  end

  # Show a success message if it uploaded correctly
  get "/success" do
    @project = params["project"]
    @doc_type = params["doc_type"]
    erb :success
  end
end
