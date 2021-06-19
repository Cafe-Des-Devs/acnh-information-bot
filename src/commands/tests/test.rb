# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def test
      AcnhBot::Command.new({ :name => :test }) do |event, _tools|
        attachment = Discordrb::Attachment.new(URI.parse("https://acnhapi.com/v1/hourly/1"), event.message, AcnhBot.client)
      end
    end
    module_function :test
  end
end
