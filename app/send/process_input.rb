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
    # Prepare and send the metadata
    metadata= prep_metadata(params)
    encrypted_metadata = encrypt_data(JSON.generate(metadata), ENV['gpg_recipient'], ENV['gpg_signer'])
    
    # Send the docs (all in tmp)
    send_uploaded_docs(encrypted_metadata, metadata[:file_path])

    # Clear files already sent
    delete_tmp
  end

  # Parses the params input and returns a hash
  def prep_metadata(params)
    # Separate out file name and save file
    file_name = "#{SecureRandom.hex}_#{params["file"]["filename"]}.gpg"
    file = params["file"]["tempfile"]
    encrypted = encrypt_data(File.read(file), ENV['gpg_recipient'], ENV['gpg_signer'])
    File.write("tmp/#{file_name}", encrypted)
    
    # Return params, including hash of file
    return {
      project: params["project"],
      doc_type: params["doc_type"],
      doc_title: params["title"],
      doc_desc: params["description"],
      file_path: file_name,
      file_hash: hash_file(encrypted)
    }
  end
end
