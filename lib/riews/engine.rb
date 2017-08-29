module Riews
  class Engine < ::Rails::Engine
    isolate_namespace Riews

    require 'kaminari'
    require 'cocoon'
    require 'acts_as_list'

    config.autoload_paths << File.expand_path('../lib', __FILE__)

    initializer 'riews.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Riews::ViewsHelper
      end
    end

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
