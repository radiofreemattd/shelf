# config.ru - run using 'rackup' at the command line

require_relative './lib/router'

stack = Rack::Builder.new do
  # use Rack::WHATEVER                => add whatever additional middleware
  # use Security::SecurityThing       => you want/need to build your web stack
  # use Cache::CacheThing             => the builder will chain them together
  run Shelf::Router
end

run stack
