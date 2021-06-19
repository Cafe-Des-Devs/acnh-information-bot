# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def villagers
      Command.new({
                    :name => :villagers,
                    :description => "Give informations about a villager",
                    :args => ["<villager name/ villager id>"],
                    :use_example => "cyrano",
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => true,
                    :ascii_only_args => true
                  }) do |event, tools|
        villager = if AcnhInformations::Api.valid?(:villagers, tools[:args][0])
                     AcnhInformations::Api.scrape(:villagers, tools[:args][0])
                   elsif AcnhInformations::Api.get_by_name(:villagers, tools[:args].join(" "))
                     AcnhInformations::Api.get_by_name(:villagers, tools[:args].join(" "))
                   else false end
        next event.respond "Your villager isn't valid. Try again." unless villager

        fields = [
          {
            :name => "• Name",
            :value => Utils.display(villager[:name][:"name-USen"])
          },
          {
            :name => "• Id",
            :value => villager[:id].to_s
          },
          {
            :name => "• Personality",
            :value => villager[:personality]
          },
          {
            :name => "• Birthday",
            :value => villager[:"birthday-string"]
          },
          {
            :name => "• Species",
            :value => villager[:species]
          },
          {
            :name => "• Gender",
            :value => villager[:gender]
          },
          {
            :name => "• Catchphrase",
            :value => villager[:"catch-phrase"]
          }
        ]
        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(fields, true, embed)
          embed.image = Discordrb::Webhooks::EmbedImage.new(:url => villager[:image_uri])
        end
      end
    end
    module_function :villagers
  end
end
