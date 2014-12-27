require 'sidekiq/web'
# require 'sidetiq/web'

# override the locale of sidekiq web
module Sidekiq
  module WebHelpers
    def locale
      'zh-cn' # sidekiq web not use 'zh-CN'
    end
  end
end
