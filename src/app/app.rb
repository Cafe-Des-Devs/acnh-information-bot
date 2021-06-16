# frozen_string_literal: true

require "discordrb"
require "json"
require "yaml"
require "acnh_informations"
require_relative "bot"
require_relative "logger"
require_relative "error"
require_relative "command_handler"
require_relative "event_handler"
require_relative "command"
require_relative "utils"
require_relative "date"

# The base module
module AcnhBot
  include Discordrb
  include JSON
  include YAML
  include AcnhInformations
  CONSOLE_LOGGER = Logger.new(:console)
  FILE_LOGGER = Logger.new(:file)
end

module AcnhBot
  APPLICATION = AcnhBot::Client.new(YAML.load_file("src/private/config.yml")[:token])

  ##
  # get the client
  def self.client
    APPLICATION.client
  end
end
