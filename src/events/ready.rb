# frozen_string_literal: true

require_relative "../app/app"

module AcnhBot
  module Events
    def ready
      $client.ready do
        AcnhBot::CONSOLE_LOGGER.info("Client login")
        $client.game = "Ruby <3"
      end
    end
    module_function :ready
  end
end
