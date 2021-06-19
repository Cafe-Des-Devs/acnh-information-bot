# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def bugs
      Command.new({
                    :name => :bugs,
                    :description => "Give informations about a bug",
                    :args => ["<bug name/ bug id>"],
                    :use_example => "seaweed",
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => true,
                    :ascii_only_args => true
                  }) do |event, tools|
        bug = if AcnhInformations::Api.valid?(:bugs, tools[:args][0])
                AcnhInformations::Api.scrape(:bugs, tools[:args][0])
              elsif AcnhInformations::Api.get_by_name(:bugs, tools[:args].join(" "))
                AcnhInformations::Api.get_by_name(:bugs, tools[:args].join(" "))
              else false end
        next event.respond "Your sea isn't valid. Try again." unless bug

        months = {
          :north => bug[:availability][:"month-array-northern"] != 12 ? bug[:availability][:"month-array-northern"].sort.map { |month| Utils.display(Utils::MONTHS[month]) }.join(", ") : false,
          :south => bug[:availability][:"month-array-southern"] != 12 ? bug[:availability][:"month-array-northern"].sort.map { |month| Utils.display(Utils::MONTHS[month]) }.join(", ") : false
        }
        fields = [
          {
            :name => "• Name",
            :value => Utils.display(bug[:name][:"name-USen"])
          },
          {
            :name => "• Id",
            :value => bug[:id].to_s
          },
          {
            :name => "• Availability (months)",
            :value => "__Northern__ : #{months[:north] || "everytime"}\n__Southern__ : #{months[:south] || "everytime"}"
          },
          {
            :name => "• Localisation",
            :value => Utils.display(bug[:availability][:location] || "everywhere")
          },
          {
            :name => "• Rarity",
            :value => Utils.display(bug[:availability][:rarity] || "un specify")
          },
          {
            :name => "• Price",
            :value => bug[:price]
          },
          {
            :name => "• Catchphrase",
            :value => bug[:"catch-phrase"]
          },
          {
            :name => "• Museum phrase",
            :value => bug[:"museum-phrase"]
          }
        ]
        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(fields, true, embed)
          embed.image = Discordrb::Webhooks::EmbedImage.new(:url => bug[:image_uri])
        end
      end
    end
    module_function :bugs
  end
end

