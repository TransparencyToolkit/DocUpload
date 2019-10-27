module ProcessInput
  # Calls methods to prepare and save docs + metadata so that OCR server can access and then cleans up after
  def parse_and_save_everything(params, project)
    # Check the number of the file
    create_save_dirs
    file_num = params.select{|p| p.include?("file")}.first[0].gsub("file", "")
 
    # Prepare metadata and save the file
    file_params = params.select{|k,v| k.include?("#{file_num}")}
    metadata = prep_metadata(file_params, project, file_num)

    # Save the metadata
    metadata_path = ENV['OCR_IN_PATH']+"/metadata/"+metadata[:file_path]+".json"
    File.write(metadata_path, JSON.pretty_generate(metadata))
  end

  # Create the directories to save in (if they don't already exist)
  def create_save_dirs
    system("mkdir -p #{ENV['OCR_IN_PATH']}/metadata")
    system("mkdir -p #{ENV['OCR_IN_PATH']}/text")
    system("mkdir -p #{ENV['OCR_IN_PATH']}/raw_docs")
    system("mkdir -p #{ENV['OCR_OUT_PATH']}/ocred_docs")
    system("mkdir -p #{ENV['OCR_OUT_PATH']}/raw_docs")
    system("mkdir -p #{ENV['OCR_OUT_PATH']}/already_indexed_json")
  end

  # Save the raw file and return the name
  def save_raw_file(params, num)
    file_read = File.read(params["file#{num}"]["tempfile"])
    file_name = "#{Digest::MD5.hexdigest(file_read)}_"+params["file#{num}"]["filename"]
    write_path = "#{ENV['OCR_IN_PATH']}/raw_docs/#{file_name}"
    
    File.write(write_path, file_read)
    return file_name
  end          

  # Parses the params input and returns a hash
  def prep_metadata(params, project, num)
    file_name = save_raw_file(params, num)
    
    # Return params, including hash of file
    return {
      project: project,
      doc_title: params["title#{num}"],
      doc_desc: params["description#{num}"],
      file_path: file_name
    }
  end
end
