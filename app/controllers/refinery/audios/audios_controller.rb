module Refinery
  module Audios
    class AudiosController < ::ApplicationController

      before_filter :find_all_audios
      before_filter :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @audio in the line below:
        present(@page)
      end

      def show
        @audio = Audio.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @audio in the line below:
        present(@page)
      end

    protected

      def find_all_audios
        @audios = Audio.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/audios").first
      end

    end
  end
end
