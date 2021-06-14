# frozen_string_literal: true

require "discordrb"
require "json"
require "yaml"
require_relative "bot"
require_relative "logger"
require_relative "error"
require_relative "command_handler"
require_relative "event_handler"
require_relative "command"
require_relative "utils"
require_relative "date"
require_relative "animal_crossing"

module AcnhBot
  include Discordrb
  include JSON
  include YAML
  CONSOLE_LOGGER = Logger.new(:console)
  FILE_LOGGER = Logger.new(:file)
end

$client = AcnhBot::Client.new(YAML.load_file("src/private/config.yml")[:token]).client
