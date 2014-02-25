# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.authors           = ['Ulyanov Dmitry']
  s.email             = ['demon@pglu.pro']
  s.name              = 'refinerycms-audios'
  s.version           = '1.0'
  s.description       = 'Manage Audios in RefineryCMS. Use HTML5 Audio.js player.'
  s.date              = '2014-02-15'
  s.summary           = 'Audios extension for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir['{app,config,db,lib}/**/*'] + %w(MIT-LICENSE Rakefile README.rdoc readme.md)

  # Runtime dependencies
  s.add_dependency             'refinerycms-core',    '~> 2.1.1'
  s.add_dependency             'audiojs',    '~> 0.1.2'

  # Development dependencies (usually used for testing)
  #s.add_development_dependency 'refinerycms-testing', '~> 2.1.1'
end
