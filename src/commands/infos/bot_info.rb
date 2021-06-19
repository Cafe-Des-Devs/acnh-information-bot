# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def bot_info
      Command.new({
                    :name => :bot_info,
                    :aliases => "bi",
                    :description => "Get informations about the bot.",
                    :args => false,
                    :use_example => :default,
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => false,
                    :ascii_only_args => false
                  }) do |event, _tools|
        fields = [
          {
            :name => "• Owner",
            :value => "#{AcnhBot.client.bot_app.owner.username}##{AcnhBot.client.bot_app.owner.discord_tag}"
          },
          {
            :name => "• Guilds count",
            :value => AcnhBot.client.servers.size
          },
          {
            :name => "• Os",
            :value => RUBY_PLATFORM
          },
          {
            :name => "• Main module",
            :value => "[AcnhInformations](https://rubygems.org/gems/acnh_informations)"
          },
          {
            :name => "• Ruby version",
            :value => RUBY_VERSION
          },
          {
            :name => "• Source code",
            :value => "[Github page](https://github.com/Cafe-Des-Devs/acnh-information-bot)"
          }
        ]

        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(fields, true, embed)
          embed.title = "Invite me!"
          embed.url = AcnhBot.client.invite_url(:server => event.server, :permission_bits => 2_218_126_529)
        end
      end
    end
    alias bi bot_info
    module_function :bot_info, :bi
  end
end
