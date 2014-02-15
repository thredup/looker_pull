require 'csv'

module LookerPull
  class Downloader
    include Logger
    attr_accessor :data_headers, :data_rows, :looker_query_utility, :filepath, :query_result, :formatter, :options

    def initialize(q, options = {})
      q = CGI.unescape(q)
      self.options = options
      self.logger = options[:logger]
      self.formatter = options[:formatter]
      self.looker_query_utility = Query.new(q, options)
      self.generate_filepath
    end

    def generate_filepath
      d = Time.now.strftime("%Y_%d_%m")
      self.filepath = "/tmp/#{filename_beginning}.csv"
    end

    def filename_beginning
      self.looker_query_utility.parser.title.gsub(" ","_")
    end

    def fetch
      start_fresh_local_file

      next_id = 0
      continue = true
      count = 0
      total_rows_count = 0
      max_rows = options[:max_rows]

      while continue && (!max_rows || max_rows > total_rows_count) && (!options[:single_pull] || next_id == 0)
        self.looker_query_utility.set_paging_by_sorts_filter(next_id) if next_id > 0
        self.looker_query_utility.run

        self.query_result = self.looker_query_utility.result

        d = self.query_result.data
        if d && d.count > 0
          total_rows_count += d.count
          self.data_headers = self.query_result.fields
          self.data_rows = d

          save_headers_to_local_file_via_append if next_id == 0

          formatter.format_data_rows(data_rows,data_headers.map{|h| h["name"]}) if formatter

          save_to_local_file_via_append
          
          next_id = d.last[0].to_i + 1
        else
          continue = false
        end
        
        next_msg = continue ? "Next starting at ID #{next_id}." : "Finished"
        log(filename_beginning, "fetch", "#{total_rows_count} records downloaded. #{next_msg}")
      end 
    end

    def start_fresh_local_file
      File.delete(filepath) if File.exist?(filepath)
    end

    def headers
      return [] if self.data_headers.nil? || self.data_headers.count == 0
      headers = self.data_headers.map do |h|
        if self.formatter
          self.formatter.format_header(h["name"])
        else
          h["name"]
        end
      end
      headers
    end

    def save_headers_to_local_file_via_append
      CSV.open(filepath, "a") { |csv| csv << headers }
      filepath
    end

    def save_to_local_file_via_append
      CSV.open(filepath, "a") do |csv|
        self.data_rows.each do |row|
          csv << row
        end
      end
      filepath
    end

    def send_archive_failed_email(f,e)
      log(f, "ERROR:save_to_dropbox:failed", "\nERROR: \n#{e.inspect}\n\n#{e.backtrace}\n\n")
      # need to implement a mailer too.
    end

  end
end
