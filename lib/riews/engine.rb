module Riews
  class Engine < ::Rails::Engine
    isolate_namespace Riews

    require 'kaminari'
  end
end
