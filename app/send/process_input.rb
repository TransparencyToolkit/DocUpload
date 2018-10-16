module ProcessInput
  include DocIntegrityCheck

  # Delete tmp uploaded files
  def delete_tmp
    Dir.glob("tmp/*").each{|f| File.delete(f)}
  end

  # Send data to OCR server. Must be in hash or other format convertable to JSON
  def send_data(data)
    # Set URL of OCR server it should send to
    url = ENV['ocrserver_url']+"/ocr"
    Curl.post(url, data)
  end

  # Send the uploaded docs. NOTE: Currently just works with one at a time in the metadata
  def send_uploaded_docs(metadata, path)
    doc = "tmp/#{path}"
    encrypted_doc = File.read(doc)
    to_send = {metadata: metadata, file: encrypted_doc}
    send_data(to_send)
  end

  # Calls methods to prepare and send docs + metadata to OCR server and then cleans up after
  def parse_and_send_everything(params)
    # Check how many files
    file_count = params.select{|k, v| k.include?("file")}.length
    
    # Prepare and send the metadata
    file_count.times do |count|
      file_params = params.select{|k,v| k.include?("#{count+1}")}
      metadata= prep_metadata(file_params, params["project"], count+1)
      encrypted_metadata = encrypt_data(JSON.generate(metadata), ENV['gpg_recipient'], ENV['gpg_signer'])
    
      # Send the docs (all in tmp)
      send_uploaded_docs(encrypted_metadata, metadata[:file_path])
    end
    
    # Clear files already sent
    delete_tmp
  end

  # Parses the params input and returns a hash
  def prep_metadata(params, project, num)
    # Separate out file name and save file
    file_name = SecureRandom.hex+"_"+params["file#{num}"]["filename"]+".gpg"
    file = params["file#{num}"]["tempfile"]
    encrypted = encrypt_data(File.read(file), ENV['gpg_recipient'], ENV['gpg_signer'])
    File.write("tmp/#{file_name}", encrypted)
    
    # Return params, including hash of file
    return {
      project: project,
      doc_title: params["title#{num}"],
      doc_desc: params["description#{num}"],
      file_path: file_name,
      file_hash: hash_file(encrypted)
    }
  end
end
