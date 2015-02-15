require 'rails_admin/adapters/mongoid'
RailsAdmin::Adapters::Mongoid::DISABLED_COLUMN_TYPES.delete('Mongoid::Geospatial::Point')

RailsAdmin.config do |config|

  config.label_methods.insert(0, :label)

  config.default_hidden_fields[:list] ||= []
  config.default_hidden_fields[:list] += [:version, :type]
  config.default_hidden_fields[:edit] += [:version, :type]
  config.default_hidden_fields[:show] += [:version, :type]
  config.default_hidden_fields[:export] ||= []
  config.default_hidden_fields[:export] += [:version, :type]

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0
  config.audit_with :mongoid_audit
  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    # root actions
    dashboard                     # mandatory

    # collection actions
    index                         # mandatory
    new
    export
    bulk_delete

    # member actions
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    history_index
    history_show
  end
end
