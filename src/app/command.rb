# frozen_string_literal: true

module AcnhBot
  # Interpret a command
  class Command
    # @!attribute run [Method] The code to tun
    # @!attribute props [Object] The command's props
    attr_reader :run
    attr_accessor :props

    # Create a command
    # @param props [Object] The command's props, for 'load_attributes' method
    # @param run [Method] The method to ru
    # @yield The command's code
    # @yieldparam event, tools The event and the tools to run the command
    # @return [Object] a hash with the props (as 'load_attributes') and the method
    def initialize(props, &run)
      @props = props
      @run = run
      @props = load_attributes
      Hash[
        :props => load_attributes,
        :run => @run
      ]
    end

    # Load command's attributes
    # @return [Object] the attributes
    def load_attributes
      Command.attr_accessor :name, :aliases, :description, :args, :strict_args, :use_example, :required_permissions, :required_bot_permissions, :category, :owner_only, :ascii_only_args
      @name = @props[:name] if @props[:name]

      @props[:aliases] ||= :default
      if @props[:aliases]
        @aliases = if @props[:aliases].instance_of?(Array) || @props[:aliases].instance_of?(String)
                     @props[:aliases]
                   elsif @aliases == :default
                     []
                   else
                     []
                   end
      end
      @description = @props[:description].to_s if @props[:description]
      @args =  if @props[:args].instance_of?(Array)
                 @props[:args]
               elsif @props[:args].instance_of?(String)
                 @args = [@props[:args]]
               else @args = [] end

      @strict_args = true if @props[:strict_args]
      @use_example = @props[:use_example] if @props[:use_example]

      @required_permissions = if @props[:required_permissions] == :default
                                []
                              elsif @props[:required_permissions].respond_to?(:to_a)
                                @props[:required_permissions].to_a
                              elsif @props[:required_permissions].instance_of?(Symbol)
                                [props[:required_permissions]]
                              else
                                []
                              end

      @required_bot_permissions ||= []
      @props[:required_bot_permissions] = [] unless @props[:required_bot_permissions].instance_of?(Array)
      if (@props[:required_bot_permissions] == :default) || !@props[:required_bot_permissions] || @props[:required_bot_permissions].empty?

        @required_bot_permissions.push(
          :add_reactions,
          :send_messages,
          :embed_links,
          :attach_files,
          :use_external_emoji
        )
      else
        @required_bot_permissions = if @props[:required_bot_permissions].respond_to?(:to_a)
                                      @props[:required_bot_permissions].to_a
                                    else []
                                    end
      end

      @category = @props[:category] || :default

      @use_example = "" if @use_example == :default
      @required_permissions = [] if @required_permissions == :default

      if (@category == :default) || !@category
        Dir.entries("src/commands/").each do |dir|
          next if %w[. ..].include?(dir)

          if Dir.entries("src/commands/#{dir}").include?("#{@name}.rb")
            @category = dir.upcase
            break
          end
        end
      end

      @owner_only = if @props[:owner_only]
                      true
                    else
                      false
                    end

      @owner_only = true if @category.upcase.match(/OWNER|TEST/)
      @ascii_only_args = if @props[:ascii_only_args]
                           true
                         else false end

      Hash[
        :name => @name,
        :aliases => @aliases,
        :description => @description,
        :args => @args,
        :strict_args => @strict_args,
        :required_permissions => @required_permissions,
        :required_bot_permissions => @required_bot_permissions,
        :use_example => @use_example,
        :category => @category,
        :owner_only => @owner_only,
        :ascii_only_args => @ascii_only_args
      ]
    end
    private :load_attributes
  end
end
