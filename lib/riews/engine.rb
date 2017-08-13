module Riews
  class Engine < ::Rails::Engine
    isolate_namespace Riews

    require 'kaminari'
    require 'cocoon'

    initializer 'riews.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper Riews::ViewsHelper
      end
    end
  end
end
