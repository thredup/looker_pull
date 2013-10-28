module LookerPull
  class Query
    attr_accessor :query_string, :query, :result, :parser, :options
    def initialize(q, options = {})
      self.query_string = q
      self.options = options
      self.parser = LookerPull::UrlParser.new(q)
      self.parser.parse
      setup_query
    end

    def run
      execute  
    end

    def setup_query
      Api.basic_setup
      self.query = Llooker::Query.new({:dictionary => self.parser.dictionary, :query => self.parser.model})
      add_sorts
      add_fields
      add_filters
      add_limit
    end

    def add_filters
      query.filters = self.parser.filters
    end
    
    def set_paging_by_sorts_filter(next_id)
      query.filters ||= {}
      
      from, to = query.filters[query.sorts].split(" to ").map(&:to_i) if query.filters[query.sorts]

      if from and to
        paging = "#{[next_id,from].max} to #{to}"
      else
        paging = "#{next_id} to"
      end

      query.filters[query.sorts] = paging
    end

    def add_fields
      query.fields = self.parser.fields
    end

    def add_sorts
      query.sorts = self.parser.sorts
    end

    def add_limit
      if options[:exclude_limit]
        query.limit = 10000
      else
        query.limit = self.parser.limit
      end
    end

    def execute
      self.result = query.run
    end

  end
end