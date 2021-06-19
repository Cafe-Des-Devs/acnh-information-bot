# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def sea
      Command.new({
                    :name => :sea,
                    :description => "Give informations about a sea creature",
                    :args => ["<sea name/ sea id>"],
                    :use_example => "seaweed",
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => true,
                    :ascii_only_args => true
                  }) do |event, tools|
        sea = if AcnhInformations::Api.valid?(:fish, tools[:args][0])
                AcnhInformations::Api.scrape(:fish, tools[:args][0])
              elsif AcnhInformations::Api.get_by_name(:fossils, tools[:args].join(" "))
                AcnhInformations::Api.get_by_name(:fish, tools[:args].join(" "))
              else false end
        next event.respond "Your sea isn't valid. Try again." unless sea

        months = {
          :north => sea[:availability][:"month-array-northern"] != 12 ? sea[:availability][:"month-array-northern"].sort.map { |month| Utils.display(Utils::MONTHS[month]) }.join(", ") : false,
          :south => sea[:availability][:"month-array-southern"] != 12 ? sea[:availability][:"month-array-northern"].sort.map { |month| Utils.display(Utils::MONTHS[month]) }.join(", ") : false
        }
        fields = [
          {
            :name => "• Name",
            :value => Utils.display(sea[:name][:"name-USen"])
          },
          {
            :name => "• Id",
            :value => sea[:id].to_s
          },
          {
            :name => "• Availability (months)",
            :value => "__Northern__ : #{months[:north] || "everytime"}\n__Southern__ : #{months[:south] || "everytime"}"
          },
          {
            :name => "• Localisation",
            :value => Utils.display(sea[:availability][:location] || "everywhere")
          },
          {
            :name => "• Rarity",
            :value => Utils.display(sea[:availability][:rarity] || "un specify")
          },
          {
            :name => "• Price",
            :value => sea[:price]
          },
          {
            :name => "• Catchphrase",
            :value => sea[:"catch-phrase"]
          },
          {
            :name => "• Museum phrase",
            :value => sea[:"museum-phrase"]
          }
        ]
        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(fields, true, embed)
          embed.image = Discordrb::Webhooks::EmbedImage.new(:url => sea[:image_uri])
        end
      end
    end
    module_function :sea
  end
end
