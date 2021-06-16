#!/usr/bin/ruby

# frozen_string_literal: true

require_relative "app/app"

cmds = AcnhBot::CommandHandler.load_commands
AcnhBot.client.commands = []

cmds.each do |cmd|
  AcnhBot.client.commands << AcnhBot::Commands.method(cmd).call if AcnhBot::Commands.respond_to?(cmd)
end

events = AcnhBot::EventHandler.load_events

events.each do |evt|
  AcnhBot::Events.method(evt).call
end

begin
  AcnhBot.client.run
rescue AcnhBot::AcnhError => e
  AcnhBot::CONSOLE_LOGGER.error(e.message)
end
