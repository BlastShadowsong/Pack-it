require 'uuid_packer'
# remove $oid from json string
module BSON
  class ObjectId
    alias :to_json :to_s
    alias :as_json :to_s

    def short
      UuidPacker.pack(to_s)
    end
  end
end

module Mongoid
  module Document
    def to_uri
      "#{self.class.to_s.underscore}_#{self.id.short}"
    end
  end
end