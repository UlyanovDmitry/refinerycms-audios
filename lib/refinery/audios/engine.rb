module Refinery
  module Audios
    class Engine < Rails::Engine
      extend Refinery::Engine
      isolate_namespace Refinery::Audios

      engine_name :refinery_audios

      require 'audiojs'

      config.before_initialize do
        unless File.exists?('config/initializers/refinery/audios.rb')
          puts "\e[33mClass `#{engine_name}` can not be created.
                Please run `rails g refinery:#{self.parent_name.split('::').last.downcase}` to generate the necessary files.\e[0m"
          exit 1
        end if defined?(Rails::Server) ||  defined?(Rails::Console)
      end

      initializer "register refinerycms_audios plugin" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "audios"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.audios_admin_audios_path }
          plugin.pathname = root
          plugin.activity = {
            :class_name => :'refinery/audios/audio'
          }
          
        end
      end

      config.after_initialize do
        Refinery.register_extension(Refinery::Audios)
      end
    end
  end
end
