# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def test
      AcnhBot::Command.new({ :name => :test }) do |event, _tools|
        event.respond AcnhInformations::Api.get_by_name(:fish, "bouvière").to_s
      end
    end
    module_function :test
  end
end
