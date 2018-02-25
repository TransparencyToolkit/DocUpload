module ProcessInput
  include DocIntegrityCheck

  # Delete tmp uploaded files
  def delete_tmp
    Dir.glob("tmp/*").each{|f| File.delete(f)}
  end

  # Slice string into appropriate size chuks for UDP
  def slice_string(str)
    size = 60000
    return Array.new(((str.length + size - 1) / size)) { |i| str.byteslice(i * size, size) }
  end

  # Send data over UDP to OCR server. Must be in hash or other format convertable to JSON
  def send_data(data)
    s = UDPSocket.new
    s.send(JSON.generate(data), 0, 'localhost', 1234)
    s.close
  end

  # Send all the uploaded docs in tmp. NOTE: Currently just works with one at a time in the metadata
  def send_uploaded_docs(metadata)
    Dir.glob("tmp/*").each do |doc|
      encrypted_doc = File.read(doc)

      # Send each slice of the doc (chunks of 60000 bytes so that UDP can handle it)
      sliced = slice_string(encrypted_doc.to_s)
      sliced.each_with_index do |slice, i|
        send_data({chunk_num: i, hash: metadata[:file_hash], slice: slice})
      end
    end
  end

  # Parse the metadata, encrypt it, and send it to OCR server
  def prep_send_metadata(params)
    # Parse and encrypt metadata
    metadata = parse_params(params)
    encrypted_metadata = encrypt_data(JSON.pretty_generate([metadata]), ENV['gpg_recipient'])

    # Send the metadata
    send_data({metadata: encrypted_metadata.to_s})
    return metadata
  end

  # Calls methods to prepare and send docs + metadata to OCR server and then cleans up after
  def parse_and_send_everything(params)
    # Prepare and send the metadata
    metadata = prep_send_metadata(params)

    # Send the docs (all in tmp)
    send_uploaded_docs(metadata)

    # Clear files already sent
    delete_tmp
  end
  

  # Parses the params input and returns a hash
  def parse_params(params)
    # Separate out file name and save file
    file_name = "#{SecureRandom.hex}_#{params["file"]["filename"]}.gpg"
    file = params["file"]["tempfile"]
    encrypted = encrypt_data(File.read(file), ENV['gpg_recipient'])
    File.write("tmp/#{file_name}", encrypted.read)
    sliced = slice_string(encrypted.to_s)
    
    # Return params, including hash of file
    return {
      project: params["project"],
      doc_title: params["title"],
      doc_desc: params["description"],
      file_path: file_name,
      num_slices: sliced.length,
      file_hash: hash_file(encrypted)
    }
  end
end
