# frozen_string_literal: true

require_relative "../app/app"

module AcnhBot
  module Events
    def message
      AcnhBot.client.message(:start_with => AcnhBot.client.config[:prefix]) do |event|
        args = event.content.slice(AcnhBot.client.config[:prefix].size, event.content.size).split(" ")
        next unless event.content.start_with?(AcnhBot.client.config[:prefix])

        name = args.shift

        if Utils.get_command(name, { :boolean => true })
          command = AcnhBot::Utils.get_command(name)

          begin
            matched_errors = []
            verified_perm = {
              :user => lambda {
                missing = []
                command.required_permissions.each do |usr_p|
                  next if event.author.permission?(usr_p)

                  missing << usr_p
                end
                missing
              },
              :client => lambda {
                missing = []
                command.required_bot_permissions.each do |bot_p|
                  next if event.server.bot.permission?(bot_p)

                  missing << bot_p
                end
                missing
              }
            }

            verified_perm_user = verified_perm[:user].call
            verified_perm_bot = verified_perm[:client].call

            matched_errors << :user_permissions unless verified_perm_user.empty?

            matched_errors << :client_permissions unless verified_perm_bot.empty?

            matched_errors << :owner if command.owner_only && !Utils.authorized?(event.author.id)

            matched_errors << :args if command.args && args.empty? && command.strict_args

            matched_errors << :ascii_only_args if command.ascii_only_args && !event.content.ascii_only?

            if matched_errors.empty?
              command.run.call(event, { :args => args })
            else
              matchs = {
                :client_permissions => "• I'm missing to l#{verified_perm_bot.size > 1 ? "es" : "a"} permission#{verified_perm_bot.size > 1 ? "es" : "a"} suivante#{verified_perm_bot.size > 1 ? "s" : ""} : #{verified_perm_bot.map do |perm|
                                                                                                                                                                                                                 Utils.display(perm.to_s)
                                                                                                                                                                                                               end.join(", ")}",
                :user_permissions => "• You are missing to l#{verified_perm_user.size > 1 ? "es" : "a"} permission#{verified_perm_user.size > 1 ? "es" : "a"} suivante#{verified_perm_user.size > 1 ? "s" : ""} : #{verified_perm_user.map do |perm|
                                                                                                                                                                                                                      Utils.display(perm.to_s)
                                                                                                                                                                                                                    end.join(", ")}",
                :owner => "• You have to being an owner to execute that.",
                :args => "• You have to precise args (#{command.args[0]}).",
                :ascii_only_args => "• Your message contain non-ascii character. (that's not expected in this command)"
              }
              event.channel.send_embed do |embed|
                embed.description = [
                  "**Problem's list (#{matched_errors.size})**",
                  matched_errors.map { |match| matchs[match] }.join("\n")
                ].join("\n")
              end
            end
          rescue StandardError => e
            CONSOLE_LOGGER.error("Error running #{command.name}: #{e.full_message}")
            FILE_LOGGER.write(e.message, :errors)
          else
            CONSOLE_LOGGER.info("Command #{command.name} executed")
          end
        end
      end
    end
    module_function :message
  end
end
