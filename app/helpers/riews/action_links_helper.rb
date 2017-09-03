module Riews
  module ActionLinksHelper
    def available_routes
      Rails.application.routes.routes.map do |r|
        route_path = r.path.spec.to_s
        displayed_name = r.name ? r.name.tr('_', ' ').capitalize : route_path
        {displayed_name => route_path}
      end.inject(:merge)
    end
  end
end
