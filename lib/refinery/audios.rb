require 'refinerycms-core'

module Refinery
  autoload :AudiosGenerator, 'generators/refinery/audios_generator'

  module Audios
    require 'refinery/audios/engine'
    require 'refinery/audios/configuration'

    class << self
      attr_writer :root

      def root
        @root ||= Pathname.new(File.expand_path('../../../', __FILE__))
      end

      def factory_paths
        @factory_paths ||= [ root.join('spec', 'factories').to_s ]
      end
    end
  end
end
