# frozen_string_literal: true

require_relative "../../app/app"

module AcnhBot
  module Commands
    def help
      Command.new({
                    :name => :help,
                    :aliases => "h",
                    :description => "Affiche le panel d'aide",
                    :args => ["[commande]"],
                    :use_example => :default,
                    :required_permissions => :default,
                    :required_bot_permissions => :default,
                    :category => :default
                  }) do |event, tools|
        if Utils.get_command((tools[:args][0]).to_s, { :boolean => true })
          command = Utils.get_command(tools[:args][0])
          command_aliases = if command.aliases.instance_of?(Array)
                              if command.aliases.empty?
                                "aucun"
                              else
                                (command.aliases.map { |a| "#{$client.config[:prefix]}#{a}" }).join("\n")
                              end
                            elsif command.aliases.instance_of?(String)
                              "#{$client.config[:prefix]}#{command.aliases}"
                            end

          command_args = if command.args
                           command.args.map { |arg| "#{$client.config[:prefix]}#{command.name} #{arg}" }.join("\n")
                         else false end
          required_permissions = if command.required_permissions && !command.required_permissions.empty?
                                   command.required_permissions.map { |perm| perm.to_s.upcase }.join(", ")
                                 else false end

          required_bot_permissions = if command.required_bot_permissions && !command.required_bot_permissions.empty?
                                       command.required_bot_permissions.map { |perm| perm }.join(", ")
                                     else false end

          fields = [
            {
              :name => "• Nom",
              :value => command.name
            },
            {
              :name => "• Alias",
              :value => command_aliases
            },
            {
              :name => "• Description",
              :value => command.description
            },
            {
              :name => "• Arguments",
              :value => command_args || "aucun"
            },
            {
              :name => "• Exemple",
              :value => "#{$client.config[:prefix]}#{command.name} #{command.use_example}"
            },
            {
              :name => "• Catégorie",
              :value => Utils.display(command.category.to_s)
            },
            {
              :name => "• Permissions utilisateur requises",
              :value => Utils.display(required_permissions || "aucune")
            },
            {
              :name => "• Permissions bot requises",
              :value => Utils.display(required_bot_permissions || "aucune")
            }
          ]
          event.channel.send_embed do |embed|
            Utils.build_embed(embed, event.message)
            Utils.add_fields(embed, fields, true)
          end
        elsif tools[:args][0] && !AcnhBot::Utils.get_command(tools[:args][0], { :boolean => true })
          event.respond "La commande n'a pas été trouvée. Veuillez réessayer."
        else
          fields = []
          categories = []

          $client.commands.each do |props|
            categories << props.category.upcase unless categories.include?(props.category)
            categories -= %w[TESTS OWNER]
          end

          categories.each do |category|
            fields << {
              :name => "• #{Utils.display(category.to_s)}",
              :value => $client.commands.filter { |cmd| cmd.category.upcase == category }.map(&:name).join(", ")
            }
          end

          event.channel.send_embed do |embed|
            Utils.build_embed(embed, event.message)
            Utils.add_fields(embed, fields, false)
            embed.title = "Liste des commandes disponibles"
          end
        end
      end
    end
    alias h help
    module_function :help
  end
end
