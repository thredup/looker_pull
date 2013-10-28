module LookerPull
  class UrlParser
    attr_accessor :url,
                  :query_params, 
                  :base_url, 
                  :model, 
                  :dictionary,
                  :fields,
                  :filters,
                  :sorts,
                  :limit,
                  :title

    def initialize(url)
      self.url = url
      self.base_url, self.query_params = url.split("?")
    end

    def parse
      parse_model
      parse_dictionary
      parse_fields
      parse_filters
      parse_sorts
      parse_limit
      parse_title
    end

    def parse_model
      url_parts = base_url.split("/")
      self.model = url_parts.last
    end

    def parse_dictionary
      url_parts = base_url.split("/")
      self.dictionary = url_parts[url_parts.count - 2]
    end

    def parse_fields
      self.fields = []

      field_list = query_param_parts_matching(/^fields/).first

      if field_list
        self.fields = field_list.gsub("fields=","").split(",")
      end

      self.fields
    end

    def parse_filters
      self.filters = {}

      filter_list = query_param_parts_matching(/^f\[/)

      filter_list.map do |filter_str|
        fitler_parts = filter_str.split("=")
        filter_name = fitler_parts[0].match(/f\[([A-Za-z0-9\_]+)\]/)[1]
        self.filters[filter_name] = fitler_parts[1]
      end

      self.filters
    end

    def parse_sorts
      sort_str = query_param_parts_matching(/^sorts/).first
      sort_arr = sort_str.split("=")
      self.sorts = sort_arr[1] if sort_arr.count > 0
    end

    def parse_limit
      limit_str = query_param_parts_matching(/^limit/).first
      limit_arr = limit_str.split("=")
      self.limit = limit_arr[1] if limit_arr.count > 0
    end

    def parse_title
      title_str = query_param_parts_matching(/^title/).first
      title_arr = title_str.split("=")
      self.title = title_arr[1] if title_arr.count > 0
    end

    def query_param_parts_matching(m)
      query_params.split("&").select{|p| p.match m }    
    end

  end
end
