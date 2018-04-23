# frozen_string_literal: true

require 'edb/version'
require 'pry'


module EDB
  if defined?(::Rails)

    ## Creates a Rails Engine
    class Engine < ::Rails::Engine
      isolate_namespace EDB

      initializer 'edb.assets.precompile' do |app|
        app.config.assets.precompile +=
          %w[*.png *.jpg *.jpeg *.gif *.eot *.svg *.ttf *.woff *.woff2]
      end
    end

  elsif defined?(::Jekyll) && defined?(::Sprockets)
    gem_path = File.expand_path '../', File.dirname(__FILE__)
    js_path = File.join gem_path, 'assets/js'
    Sprockets.append_path(js_path)
  end

end