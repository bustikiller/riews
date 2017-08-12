module Riews
  class Engine < ::Rails::Engine
    isolate_namespace Riews

    require 'kaminari'
    require 'cocoon'
  end
end
