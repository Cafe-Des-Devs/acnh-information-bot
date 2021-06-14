# frozen_string_literal: true

require_relative "../app/app"

module AcnhBot
  module Events
    def server_create
      $client.server_create do |_event|
        $client.channel($client.config[:server_create_or_delete]).send_embed do |embed|
          AcnhBot::Utils.build_embed(embed)
        end
      end
    end
    module_function :server_create
  end
end
