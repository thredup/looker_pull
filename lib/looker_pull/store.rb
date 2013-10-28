module LookerPull
  class Store
    include Logger
    
    attr_accessor :data_filepath, :options

    def initialize(data_filepath, options = {})
      self.data_filepath = data_filepath
      self.options = merge_defaults(options)
      self.logger = options[:logger]
    end

    def merge_defaults(opts)
      {
        logger: nil
      }.merge(opts)
    end

    def to_dropbox(dropbox_session, dropbox_folder, dropbox_filename = nil)
      dropbox_filename ||= default_stored_filename
      log("beginning:#{__method__}","dropbox upload","Beginning dropbox upload")
      begin
        file = open(data_filepath)
        uploader = dropbox_session.client.get_chunked_uploader(file, file.size)
        
        uploader.upload

        uploader.finish(dropbox_filepath(dropbox_folder,dropbox_filename),true)
        log("finished:#{__method__}:#{data_filepath}","dropbox upload","Finished dropbox upload")
      rescue => e
        log("ERROR:#{__method__}",e.inspect,e.backtrace)
      end
    end

    def default_stored_filename
      data_filepath.split("/").last
    end
    
    def dropbox_filepath(folder,filename)
      "#{folder}/#{filename}"
    end

  end
end
