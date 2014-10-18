PDFKit.configure do |config|
  config.default_options = {
    print_media_type: false,
    encoding: "UTF-8",
    disable_smart_shrinking: false,
    page_size: 'Legal'
  }

end
