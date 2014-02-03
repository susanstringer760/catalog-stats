# requireall: mkdir foo && ln -s requireall.rb foo.rb && echo 'foo/*.rb' are all required
filepattern = File.join( File.dirname(__FILE__), File.basename(__FILE__,'.*'), '*.rb' )

Dir[filepattern].each{ |f| require f }
