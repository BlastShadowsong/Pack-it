require 'openssl'
require 'base64'

class HybridCrypt

  def initialize(timestamp_drift = ENV['AES_TIMESTAMP_DRIFT'],
                 rsa_public_key = ENV['RSA_PUBLIC_KEY'],
                 rsa_private_key = ENV['RSA_PRIVATE_KEY'],
                 rsa_pass_phrase = ENV['RSA_PASS_PHRASE'])
    @use_timestamp_iv = !!timestamp_drift
    @timestamp_drift = timestamp_drift.to_i if @use_timestamp_iv
    # openssl genrsa -des3 -out private.pem 2048 # 256..2048
    # openssl rsa -in private.pem -out public.pem -outform PEM -pubout
    @rsa_public_key = rsa_public_key
    @rsa_private_key = rsa_private_key
    @rsa_pass_phrase = rsa_pass_phrase
  end

  def encrypt(data)
    # AES: encrypt the data
    cipher = OpenSSL::Cipher.new('AES-128-CBC')
    cipher.encrypt
    key = cipher.random_key
    if @use_timestamp_iv
      iv = cipher.iv = Time.now.to_f.to_s[0, 16]
    else
      iv = cipher.random_iv
    end

    encrypted_data = Base64.encode64(cipher.update(data) + cipher.final)

    # RSA: encrypt the AES key
    public_key = OpenSSL::PKey::RSA.new(@rsa_public_key)
    encrypted_key = Base64.encode64(public_key.public_encrypt(key))
    encrypted_iv = Base64.encode64(public_key.public_encrypt(iv)) if iv

    [encrypted_data, encrypted_key, encrypted_iv].join(',')
  end

  def decrypt(encrypted_string)
    return encrypted_string unless valid?(encrypted_string)

    # [data, key, iv]
    encrypted_ary = encrypted_string.split(',')
    encrypted_data = encrypted_ary[0]
    encrypted_key = encrypted_ary[1]
    encrypted_iv = encrypted_ary[2]

    # RSA: decrypt the AES key
    private_key = OpenSSL::PKey::RSA.new(@rsa_private_key, @rsa_pass_phrase)
    decrypted_key = private_key.private_decrypt(Base64.decode64(encrypted_key))
    decrypted_iv = private_key.private_decrypt(Base64.decode64(encrypted_iv))


    # validate the timestamp from iv
    return encrypted_string if @use_timestamp_iv && Time.now.to_i - decrypted_iv.to_i > @timestamp_drift


    # AES: decrypt the data
    decipher = OpenSSL::Cipher.new('AES-128-CBC')
    decipher.decrypt
    decipher.key = decrypted_key
    decipher.iv = decrypted_iv

    decipher.update(Base64.decode64(encrypted_data)) + decipher.final
  end

  def valid?(encrypted_string)
    self.class.valid?(encrypted_string)
  end

  def self.valid?(encrypted_string)
    # the length of encrypted_string must be greater than 92=len(key+iv)
    # the encrypted_string must has 2 commas
    !!(encrypted_string &&
        encrypted_string.length > 92 &&
        encrypted_string.count(',') == 2
    )
  end
end