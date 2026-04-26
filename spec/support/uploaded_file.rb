require "mini_magick"

module UploadedFileHelper
  # Cria um JPEG quadrado em memória para uso em testes de upload de banner.
  def banner_upload(size: 800, ext: "jpg")
    path = Rails.root.join("tmp/test_banner_#{SecureRandom.hex(4)}.#{ext}")
    MiniMagick.convert do |cmd|
      cmd.size "#{size}x#{size}"
      cmd << "xc:lightblue"
      cmd.flatten
      cmd << path.to_s
    end

    content_type = ext == "png" ? "image/png" : "image/jpeg"
    Rack::Test::UploadedFile.new(path, content_type)
  end
end

RSpec.configure do |config|
  config.include UploadedFileHelper
end
