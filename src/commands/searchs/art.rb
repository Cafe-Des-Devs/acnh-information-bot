# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def art
      Command.new({
                    :name => :art,
                    :description => "Give informations about an art piece",
                    :args => ["<art name/ art id>"],
                    :use_example => "academic painting",
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => true,
                    :ascii_only_args => true
                  }) do |event, tools|
        art = if AcnhInformations::Api.valid?(:art, tools[:args][0])
                AcnhInformations::Api.scrape(:art, tools[:args][0])
              elsif AcnhInformations::Api.get_by_name(:art, tools[:args].join(" "))
                AcnhInformations::Api.get_by_name(:art, tools[:args].join(" "))
              else false end
        next event.respond "Your art isn't valid. Try again." unless art

        fields = [
          {
            :name => "• Name",
            :value => Utils.display(art[:name][:"name-USen"])
          },
          {
            :name => "• Id",
            :value => art[:id].to_s
          },
          {
            :name => "• Has fake",
            :value => art[:hasFake] ? "Yes" : "No"
          },
          {
            :name => "• Buy price",
            :value => art[:"buy-price"]
          },
          {
            :name => "• Sell price",
            :value => art[:"sell-price"]
          },
          {
            :name => "• Museum description",
            :value => art[:"museum-desc"]
          }
        ]
        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(fields, true, embed)
          embed.image = Discordrb::Webhooks::EmbedImage.new(:url => art[:image_uri])
        end
      end
    end
    module_function :art
  end
end

