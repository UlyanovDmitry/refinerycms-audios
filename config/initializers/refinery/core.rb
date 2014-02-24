Refinery::Core.configure do |config|

  # Add extra tags to the wymeditor whitelist e.g. = {'tag' => {'attributes' => {'1' => 'href'}}} or just {'tag' => {}}
  config.wymeditor_whitelist_tags.merge!({
      'audio'  =>  {
          'attributes'  =>  {
              '1'  =>  'width' ,
              '2'  =>  'height' ,
              '3'  =>  'controls',
              '4'  =>  'preload',
              '5'  =>  'autoplay',
              '6'  =>  'src'
          }
      },
      'source'  =>  {
          'attributes'  =>  {
              '1'  =>  'src' ,
              '2'  =>  'type'
          }
      }
  }
  )

  # Register extra javascript for backend
  config.register_javascript 'refinery/audios/admin/form_valid'
  config.register_javascript 'refinery/audios/admin/wymeditor_add_audios'
  config.register_javascript 'refinery-audios'

  #Register extra stylesheet for backend (optional options)
  config.register_stylesheet 'refinery/audios/admin/audio'
  config.register_stylesheet 'refinery-audios'
end