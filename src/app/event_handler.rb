# frozen_string_literal: true

module AcnhBot
  # Manage the events
  module EventHandler
    # Load the events
    # @return [Array] all the events
    def load_events
      events = []
      dir = Dir.entries("src/events/")
      dir.each do |file|
        next if %w(. ..).include?(file)

        load "src/events/#{file}"
        events << File.basename(file, ".rb")
      end
      AcnhBot::CONSOLE_LOGGER.check("#{events.length} event#{events.length > 1 ? "s" : ""} loaded")
      events
    end
    module_function :load_events
  end
end
