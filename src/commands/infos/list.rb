# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def list
      Command.new({
                    :name => :list,
                    :description => "Get the list of a category.",
                    :args => %w[<category> <available>],
                    :use_example => "fish",
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default,
                    :strict_args => true,
                    :ascii_only_args => false
                  }) do |event, tools|
        next event.respond "The available categories are #{(AcnhInformations::Api::CATEGORIES - %w[icons images music houseware]).map { |c| "`#{c}`" }.join(", ")}" if tools[:args][0] == "available"

        listed = AcnhInformations::Api.scrape(tools[:args][0]) || false
        number = 0
        page = 0
        next event.respond "Your research isn't valid. Try again." unless listed

        listed = listed.keys.each_slice(25).to_a
        listed.each do |segment|
          segment.map! do |element|
            "#{number += 1}. #{element}"
          end
        end

        message = event.channel.send_embed do |embed|
          Utils.build_embed(embed, event.message)
          embed.description = listed[page].join("\n")
        end
        %w[⬅️ ➡].each { |x| message.create_reaction(x) }
        AcnhBot.client.reaction_add do |reaction_event|
          p reaction_event.emoji.name
          next unless reaction_event.message == event.message || %w[⬅️ ➡].include?(reaction_event.emoji.name) || reaction_event.user.id == event.message.author.id

          case reaction_event.emoji.name
          when "⬅️"
            next message.delete_reaction(event.author, "⬅️") if page.zero?

            page -= 1
            embed = Discordrb::Webhooks::Embed.new
            Utils.build_embed(embed, event.message)
            embed.description = listed[page].join("\n")

            message.delete_reaction(event.author, "⬅️")
            message.edit("", embed)
          when "➡"
            p "Right"
            next message.delete_reaction(event.author, "⬅") if page == listed.size

            page += 1
            embed = Discordrb::Webhooks::Embed.new
            Utils.build_embed(embed, event.message)
            embed.description = listed[page].join("\n")

            message.delete_reaction(event.author, "➡")
            message.edit("", embed)
          else next end
        end
      end
    end
    module_function :list
  end
end
