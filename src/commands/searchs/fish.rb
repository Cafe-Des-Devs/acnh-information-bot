# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def fish
      Command.new({
                    :name => :fish,
                    :aliases => "poisson",
                    :description => "Give informations about a fish",
                    :args => ["<fish name/ fish id>"],
                    :use_example => "bitterling",
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => true,
                    :ascii_only_args => true
                  }) do |event, tools|
        fish = if AcnhInformations::Api.valid?(:fish, tools[:args][0])
                 AcnhInformations::Api.scrape(:fish, tools[:args][0])
               elsif AcnhInformations::Api.get_by_name(:fish, tools[:args].join(" "))
                 AcnhInformations::Api.get_by_name(:fish, tools[:args].join(" "))
               else false end
        next event.respond "Your fish isn't valid. Try again." unless fish

        months = {
          :north => fish[:availability][:"month-array-northern"] != 12 ? fish[:availability][:"month-array-northern"].sort.map { |month| Utils.display(Utils::MONTHS[month]) }.join(", ") : false,
          :south => fish[:availability][:"month-array-southern"] != 12 ? fish[:availability][:"month-array-northern"].sort.map { |month| Utils.display(Utils::MONTHS[month]) }.join(", ") : false
        }
        fields = [
          {
            :name => "• Name",
            :value => Utils.display(fish[:name][:"name-USen"])
          },
          {
            :name => "• Id",
            :value => fish[:id].to_s
          },
          {
            :name => "• Availability (months)",
            :value => "__Northern__ : #{months[:north] || "everytime"}\n__Southern__ : #{months[:south] || "everytime"}"
          },
          {
            :name => "• Localisation",
            :value => Utils.display(fish[:availability][:location] || "everywhere")
          },
          {
            :name => "• Rarity",
            :value => Utils.display(fish[:availability][:rarity] || "un specify")
          },
          {
            :name => "• Price",
            :value => fish[:price]
          },
          {
            :name => "• Catchphrase",
            :value => fish[:"catch-phrase"]
          },
          {
            :name => "• Museum phrase",
            :value => fish[:"museum-phrase"]
          }
        ]
        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(fields, true, embed)
          embed.image = Discordrb::Webhooks::EmbedImage.new(:url => fish[:image_uri])
        end
      end
    end
    alias poisson fish
    module_function :fish, :poisson
  end
end
