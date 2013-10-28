module LookerPull
  module Logger
    def self.included(klass)
      klass.send :attr_accessor, :logger
    end

    def log(t, s, m)
      self.logger.info({:time_float => Time.now.utc.to_f, :time => Time.now.utc.to_s, :task => t, :next_step => s, :message => m}.to_json) if self.logger
    end
  end
end