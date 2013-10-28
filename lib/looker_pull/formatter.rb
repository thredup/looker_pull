module LookerPull
  class Formatter
    
    def initialize(formatting_options = {})
      @header_mappings = reorganize_header_mappings(formatting_options[:header_mappings])
      @header_gsubs = formatting_options[:header_gsubs]
      @currency_fields = formatting_options[:currency_fields]
    end

    def reorganize_header_mappings(original_mappings)
      return nil if original_mappings.nil?

      remapped = {}

      original_mappings.each do |mapping|
        mapping[:applicable_fields].each do |field|
          remapped[field] ||= {}
          remapped[field][:prepend] = mapping[:prepend] if mapping[:prepend]
          remapped[field][:append] = mapping[:append] if mapping[:append]
        end
      end

      remapped
    end

    def format_header(h)
      formatted_header = h
      
      formatted_header = process_mapping(formatted_header) if @header_mappings
      formatted_header = process_gsubs(formatted_header) if @header_gsubs
      
      formatted_header
    end

    def process_mapping(h)
      mapping = @header_mappings[h.to_sym]
      
      if mapping
        h = "#{h}#{mapping[:append]}" if mapping[:append]
        h = "#{mapping[:prepend]}#{h}" if mapping[:prepend]
      end

      h
    end

    def process_gsubs(h)
      @header_gsubs.each do |from,to|
        h.gsub!(from,to)
      end
      h
    end

    def format_data_rows(rows,headers)
      rows = format_currency_fields(rows,headers)
    end

    def format_currency_fields(rows,headers)
      (@currency_fields.map(&:to_s) & headers.map(&:to_s)).each do |field|
        if ind = headers.index(field)
          rows.each do |row|
            row[ind] = row[ind] / 100.0 if row[ind]
          end
        end
      end
    end
  end
end

