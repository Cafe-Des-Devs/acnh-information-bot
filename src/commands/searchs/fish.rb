# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def fish
      Command.new({
                    :name => :fish,
                    :aliases => "poisson",
                    :description => "Give informations about the fish",
                    :args => ["<fish name/ fish id>"],
                    :use_example => "bitterling",
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => true
                  }) do |event, tools|
        fish = if AcnhInformations::Api.valid?(:fish, tools[:args][0])
                 AcnhInformations::Api.scrape(:fish, tools[:args][0])
               elsif AcnhInformations::Api.get_by_name(:fish, tools[:args].join(" "))
                 AcnhInformations::Api.get_by_name(:fish, tools[:args].join(" "))
               else false end
        next event.respond "Your research isn't valid. Try again." unless fish

        fields = []

        event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          Utils.add_fields(embed, fields, true)
          embed.image = Discordrb::Webhooks::EmbedImage.new(:url => fish[:image_uri])
        end
      end
    end
    alias poisson fish
    module_function :fish
  end
end
