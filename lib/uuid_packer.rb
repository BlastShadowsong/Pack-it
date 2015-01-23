class UuidPacker
  def self.pack(uuid)
    [[uuid].pack('H*')].pack('m0')
  end

  def self.unpack(short_uuid)
    short_uuid.unpack('m0').first.unpack('H*').first
  end
end