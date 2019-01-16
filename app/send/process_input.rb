module ProcessInput
  include DocIntegrityCheck

  tmp_dir = ENV['docupload_tmpdir'] || 'tmp'

  # Send data to OCR server. Must be in hash or other format convertable to JSON
  def send_data(data)
    # Set URL of OCR server it should send to
    url = ENV['ocrserver_url']+"/ocr"
    Curl.post(url, data)
  end

  # Send the uploaded docs. NOTE: Currently just works with one at a time in the metadata
  def send_uploaded_docs(metadata, path)
    doc = "#{tmp_dir}/#{path}"
    encrypted_doc = File.read(doc)
    to_send = {metadata: metadata, file: encrypted_doc}
    send_data(to_send)
    # Cleanup after passing it on by deleting it:
    File.delete(doc)
  end

  # Calls methods to prepare and send docs + metadata to OCR server and then cleans up after
  def parse_and_send_everything(params)
    # Check the number of the file
    file_num = params.select{|p| p.include?("file")}.first[0].gsub("file", "")
 
    # Prepare and send the metadata
    file_params = params.select{|k,v| k.include?("#{file_num}")}
    metadata= prep_metadata(file_params, params["project"], file_num)
    encrypted_metadata = encrypt_data(JSON.generate(metadata), ENV['gpg_recipient'], ENV['gpg_signer'])
    
    # Send the docs (all in tmp_dir)
    send_uploaded_docs(encrypted_metadata, metadata[:file_path])
  end

  # Parses the params input and returns a hash
  def prep_metadata(params, project, num)
    # Separate out file name and save file
    file_name = SecureRandom.hex+"_"+params["file#{num}"]["filename"]+".gpg"
    file = params["file#{num}"]["tempfile"]
    encrypted = encrypt_data(File.read(file), ENV['gpg_recipient'], ENV['gpg_signer'])
    File.write("#{tmp_dir}/#{file_name}", encrypted)
    
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
