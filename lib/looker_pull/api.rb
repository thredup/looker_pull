require 'llooker_sdk'
module LookerPull
  module Api

    extend self

    def basic_setup(options = {})
      default_options = {
        :token => LOOKER[:token],
        :secret => LOOKER[:secret],
        :host => LOOKER[:host],
        :port => LOOKER[:port],
        :read_timeout => 72000
      }

      Llooker.setup(default_options.merge(options))
    end
  end
end