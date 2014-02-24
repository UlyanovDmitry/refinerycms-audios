module Refinery
  module Audios
    module Admin
      class AudiosController < ::Refinery::AdminController

        include ActionView::Helpers::NumberHelper
        rescue_from Exception, :with => :exception_work

        crudify :'refinery/audios/audio',
                :title_attribute => 'title',
                :xhr_paging => true,
                :order => 'created_at DESC'

        def create
          @message_error = ''
          if request.post?
            file_url_path = ''
            begin
              directory_path = Refinery::Audios.datastore_root_path
              file_prefix = Refinery::Audios.file_prefix
              param_upload_file = params[:audio][:file]
              if param_upload_file
                file_data = param_upload_file.read
                # все допустимые типы файлов для данного раздела
                file_content_types = Refinery::Audios.whitelisted_mime_types
                file_content_type = file_content_types.find_all{|cntp| cntp.to_s == param_upload_file.content_type.chomp.to_s}
                if file_content_type.any?
                  # тип загружаемого файла
                  file_content_type = file_content_type.first
                  if file_data.length.to_i > Refinery::Audios.max_file_size.to_i
                    @message_error = t 'file_big_size', :scope => 'refinery.videos.admin.videos.errors', :big_file_size => number_to_human_size(file_data.length), :norm_file_size => number_to_human_size(Refinery::Audios.max_file_size)
                  else
                    # все проверки пройдены - пишем файла
                    file_type = param_upload_file.original_filename.split('.').last
                    Audio.transaction do
                      # дополнительные приготовления и задание оригинального имени по назанчению файла
                      @original_file_name = param_upload_file.original_filename.to_s
                      new_data_file = Audio.new(:file_name => @original_file_name,:title => params[:audio][:title].to_s, :file_mime_type => file_content_type, :file_size => file_data.length.to_i)
                      this_data_file_id = new_data_file.object_id
                      file_url_name = "#{file_prefix}_#{current_time_text}_#{this_data_file_id}.#{file_type}"
                      file_url_path = "#{directory_path}/#{file_url_name}"
                      new_data_file.file_url_name = file_url_name
                      if new_data_file.save


                        FileUtils.mkdir_p(directory_path) unless File.exists?(directory_path)
                        File.open(file_url_path, 'wb'){|f| f.write(file_data)}
                        flash[:notice] = t 'successfully_finish', scope: 'refinery.audios.admin.audios.upload', file_title: new_data_file.get_title
                      else
                        @message_error = t 'bd_errors', scope: 'refinery.audios.admin.audios.errors'
                      end
                    end
                  end
                else
                  @message_error = t('file_type_uncorrect', scope: 'refinery.audios.admin.audios.errors')
                  #@message_error += " || #{param_upload_file.content_type.chomp.to_s}" if Rails.env.to_s == 'development'
                end
              else
                @message_error = t('file_is_null', scope: 'refinery.audios.admin.audios.errors')
              end
            rescue => exp
              File.delete file_url_path if File.exists? file_url_path unless file_url_path.blank?
              #ignored
              raise exp
            end
          end
          @dialog_successful = from_dialog?
          unless @message_error.blank?
            flash[:error] = @message_error.to_s
            self.new # important for dialogs
            render :action => :new
          else
            redirect_to_index
          end
          #create_or_update_successful
        end


        def download
          audio_id = params[:audio_id].to_i
          audio_base = Audio.find(audio_id)
          directory_path = Refinery::Audios.datastore_root_path
          file_url_path = "#{directory_path}/#{audio_base.file_url_name}"
          if File.exist? file_url_path
            send_file(file_url_path, :filename => audio_base.file_name, :type => audio_base.file_mime_type, :stream=>false, :disposition=>"attachment")
          else
            exception_file_not_found file_url_path
          end
        end


        def edit
          @audio_id = params[:id].to_i
          @audio = Audio.find(@audio_id)
          directory_path = Refinery::Audios.datastore_root_path
          file_url_path = "#{directory_path}/#{@audio.file_url_name}"
          exception_file_not_found file_url_path unless File.exist? file_url_path
        end


        def update
          audio_id = params[:id].to_i
          Audio.transaction do
            audio_title = params[:audio][:title].to_s
            audio_description = params[:audio][:description].to_s
            @audio = Audio.update(audio_id, {title: audio_title, description: audio_description})
            if @audio.valid?
              flash[:notice] = t 'successfully_finish', scope: 'refinery.audios.admin.audios.update', file_title: @audio.get_title
              redirect_to_index
            else
              render :action => :edit
            end
          end
        end


        def destroy
          audio_id = params[:id].to_i
          audio = Audio.find(audio_id)
          directory_path = Refinery::Audio.datastore_root_path
          Audio.transaction do
            audio_title = audio.get_title
            #Audio.destroy
            if audio.destroy
              file_url_path = "#{directory_path}/#{audio.file_url_name}"
              File.delete file_url_path if File.exist? file_url_path unless audio.file_url_name.blank?
              flash[:notice] = t 'successfully_finish', scope: 'refinery.audios.admin.audios.destroy', file_title: audio_title
              if from_dialog?
                @dialog_successful = true
                render :nothing => true, :layout => true
              else
                redirect_to refinery.videos_admin_videos_path and return
              end
            else
              @message_error = t 'bd_errors', scope: 'refinery.audios.admin.audios.errors'
            end
          end
          unless @message_error.nil?
            flash[:error] = @message_error
            redirect_to_index
          end
        end



        def insert
          searching? ? search_all_audios : find_all_audios
          paginate_all_audios
          if request.xhr?
            render '_insert_list_audios', :layout => false
          else
            @default_width = Refinery::Audios.audio_default_width
            #@default_height = Refinery::Audios.audio_default_height
          end
        end

        def audio_to_html
          if request.xhr?
            @tab_name = params[:tab_name].to_s
            if @tab_name == 'insert_preview'
              @audio = Audio.find(params[:audio_id].to_i)
            elsif @tab_name == 'append_to_wym'
              @audio = Audio.find(params[:audio_id].to_i)
              @audio_width = params[:width].to_i
            else
              @tab_name = ''
            end
          else
            render :nothing => true, :layout => false, :status => 404
          end
        end
        
        private


        def paginate_per_page
          from_dialog? ? Refinery::Audios.pages_per_dialog : Refinery::Audios.pages_per_admin_index
        end


        def current_time_text
          current_time = Time.now
          #"#{current_time.year}-#{current_time.month}-#{current_time.day}_#{current_time.hour}-#{current_time.min}"
          "#{current_time.year}#{current_time.month}#{current_time.day}#{current_time.hour}#{current_time.min}"
        end

        def exception_work(exp)
          puts "Error: #{exp.class} - '#{exp.message}'"
          if exp.class == ActiveRecord::RecordNotFound
            exception_redirect_to_index 'search_bd_of_null'
          elsif exp.class == EOFError && exp.message.start_with?('RefineryAudioFile not found')
            exception_redirect_to_index 'search_file_of_null'
          elsif exp.class == ActionView::MissingTemplate
            render file: 'public/404.html', :status => 404
          else
            raise exp
          end
        end

        def exception_redirect_to_index(translate_error_text = t('translate_error_text', :scope => 'refinery.audios.admin.audios.errors'))
          flash[:error] = t translate_error_text.to_s, :scope => 'refinery.audios.admin.audios.errors'
          redirect_to_index
        end

        def redirect_to_index
          if from_dialog?
            @dialog_successful = true
            render :nothing => true, :layout => true and return
          else
            redirect_to refinery.audios_admin_audios_path and return
          end
        end

        def exception_file_not_found(file_name)
          raise EOFError, "RefineryAudioFile not found: #{file_url_path}"
        end


        # end class
      end
    end
  end
end
