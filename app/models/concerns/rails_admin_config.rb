module RailsAdminConfig
  extend ActiveSupport::Concern
  included do
    rails_admin do
      list do
        exclude_fields :creator, :updater
      end
      edit do
        exclude_fields :creator, :updater
      end
      show do
        exclude_fields :creator, :updater
      end
      export do
        exclude_fields :creator, :updater
      end
    end
  end
end