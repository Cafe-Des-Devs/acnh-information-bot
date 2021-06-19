# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def fossils
      Command.new({
                    :name => :fossils,
                    :description => "Give informations about a fossil",
                    :args => ["<fossil name>"],
                    :use_example => "amber",
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => true,
                    :ascii_only_args => true
                  }) do |event, tools|
        fossil = if AcnhInformations::Api.valid?(:fossils, tools[:args][0])
                   AcnhInformations::Api.scrape(:fossils, tools[:args][0])
                 elsif AcnhInformations::Api.get_by_name(:fossils, tools[:args].join(" "))
                   AcnhInformations::Api.get_by_name(:fossils, tools[:args].join(" "))
                 else false end
        next event.respond "Your fossil isn't valid. Try again." unless fossil

        fields = [
          {
            :name => "• Name",
            :value => Utils.display(fossil[:name][:"name-USen"])
          },
          {
            :name => "• Price",
            :value => fossil[:price]
          },
          {
            :name => "• Museum phrase",
            :value => fossil[:"museum-phrase"]
          }
        ]
        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(fields, true, embed)
          embed.image = Discordrb::Webhooks::EmbedImage.new(:url => fossil[:image_uri])
        end
      end
    end
    module_function :fossils
  end
end
