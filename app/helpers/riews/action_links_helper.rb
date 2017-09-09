module Riews
  module ActionLinksHelper
    def available_routes
      Rails.application.routes.routes.map do |r|
        route_path = r.path.spec.to_s
        displayed_name = r.name ? r.name.tr('_', ' ').capitalize : route_path
        {displayed_name => route_path}
      end.inject(:merge)
    end

    def http_verbs
      Riews::ActionLink.http_verbs.values.map(&:values).map(&:reverse).to_h
    end
  end
end
