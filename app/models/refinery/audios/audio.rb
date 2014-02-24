module Refinery
  module Audios
    class Audio < Refinery::Core::BaseModel
      self.table_name = 'refinery_audios'


      attr_accessible :title, :description, :position, :file_name, :file_mime_type, :file_url_name, :file_size

      #attr_accessible :file

      #validates :file, :presence => true

      #delegate :ext, :size, :mime_type, :url, :to => :file

      validates :title, :presence => true
      validates :title, :uniqueness => true


      def download_url
        "/#{Refinery::Audios.datastore_path}/#{self.file_url_name}"
      end

      def get_title
        self.title || self.file_name
      end

      def get_file_ext
        self.file_name.split('.').last
      rescue
        ''
      end


      class << self

        def with_query(search_text = '')
          where(["lower(title) like lower(?)", "%#{search_text}%"])
        end

      end

    end
  end
end
