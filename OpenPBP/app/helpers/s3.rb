
def s3_initialize
  Aws::S3::Resource.new(
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: ENV['AWS_REGION']
)
end

def file_upload(file, folder)
  s3 = s3_initialize()
  filename = SecureRandom.urlsafe_base64(16, false) + File.extname(file[:tempfile])
  if s3.bucket(ENV['AWS_S3_BUCKET']).object("#{folder}/#{filename}").upload_file(file[:tempfile])
    filename
  end
end

def file_replace(current_file, file, folder)
  s3 = s3_initialize()
  filename = SecureRandom.urlsafe_base64(16, false) + File.extname(file[:tempfile])
  if s3.bucket(ENV['AWS_S3_BUCKET']).object("#{folder}/#{filename}").upload_file(file[:tempfile])
    if current_file != nil
      s3.bucket(ENV['AWS_S3_BUCKET']).object("#{folder}/#{current_file}").delete
    end
    filename
  end
end

def file_upload_cropped(tempfile, folder)
  s3 = s3_initialize()
  filename = SecureRandom.urlsafe_base64(16, false) + ".png"
  if s3.bucket(ENV['AWS_S3_BUCKET']).object("#{folder}/#{filename}").upload_file(tempfile)
    filename
  end
end

def file_replace_cropped(current_file, tempfile, folder)
  s3 = s3_initialize()
  filename = SecureRandom.urlsafe_base64(16, false) + ".png"
  if s3.bucket(ENV['AWS_S3_BUCKET']).object("#{folder}/#{filename}").upload_file(tempfile)
    if current_file != nil
      s3.bucket(ENV['AWS_S3_BUCKET']).object("#{folder}/#{current_file}").delete
    end
    filename
  end
end

def file_delete(file, folder)
  s3 = s3_initialize()
  s3.bucket(ENV['AWS_S3_BUCKET']).object("#{folder}/#{file}").delete
end

def base64_to_blob(base64)
  data = base64.gsub(/^.*,/, '')
  blob = Base64.decode64(data)
  blob
end

def blob_to_tempfile(blob)
  tempfile = "/tmp/" + SecureRandom.urlsafe_base64(16, false) + ".png"
  File.open(tempfile, 'w') {|f| f.write(blob)}
  tempfile
end