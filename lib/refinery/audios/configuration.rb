module Refinery
  module Audios
    include ActiveSupport::Configurable

    config_accessor :datastore_root_path, :whitelisted_mime_types, :max_file_size, :file_prefix, :pages_per_dialog,
                    :pages_per_admin_index, :datastore_path, :skin_css_class,:audio_default_width



    # my config

    self.max_file_size = 104857600
    self.file_prefix = 'video'
    self.whitelisted_mime_types = %w(audio/mp3)
    self.pages_per_admin_index = 10
    self.pages_per_dialog = 7
    self.audio_default_width = 375
    self.datastore_path = 'system/plugins/audios'
    #end my-config


    class << self
      def datastore_root_path
        config.datastore_root_path || (Rails.root.join('public', self.datastore_path).to_s if Rails.root)
      end
    end
  end
end
