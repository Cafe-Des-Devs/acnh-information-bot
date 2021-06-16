# frozen_string_literal: true

require_relative "../app/app"

module AcnhBot
  module Events
    def ready
      AcnhBot.client.ready do
        AcnhBot::CONSOLE_LOGGER.info("Client login")
        AcnhBot.client.game = "#{AcnhBot.client.config[:prefix]}help <3"
      end
    end
    module_function :ready
  end
end
