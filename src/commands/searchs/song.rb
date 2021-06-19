# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def songs
      Command.new({
                    :name => :songs,
                    :description => "Give informations about a song",
                    :args => ["<song name/ song id>"],
                    :use_example => "",
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => true,
                    :ascii_only_args => true
                  }) do |event, tools|
        song = if AcnhInformations::Api.valid?(:songs, tools[:args][0])
                AcnhInformations::Api.scrape(:songs, tools[:args][0])
              elsif AcnhInformations::Api.get_by_name(:songs, tools[:args].join(" "))
                AcnhInformations::Api.get_by_name(:songs, tools[:args].join(" "))
              else false end
        next event.respond "Your song isn't valid. Try again." unless song

        fields = [
          {
            :name => "• Name",
            :value => Utils.display(song[:name][:"name-USen"])
          },
          {
            :name => "• Id",
            :value => song[:id].to_s
          },
          {
            :name => "• Buy price",
            :value => song[:"buy-price"]
          },
          {
            :name => "• Sell price",
            :value => song[:"sell-price"]
          },
          {
            :name => "• Music link",
            :value => "[#{Utils.display(song[:name][:"name-USen"])}](#{song[:music_uri]})"
          }
        ]
        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(fields, true, embed)
          embed.image = Discordrb::Webhooks::EmbedImage.new(:url => song[:image_uri])
        end
      end
    end
    module_function :songs
  end
end

