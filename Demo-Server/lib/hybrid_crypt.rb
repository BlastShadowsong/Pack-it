require 'openssl'
require 'base64'

class HybridCrypt

  def initialize(rsa_pass_phrase = ENV['RSA_PASS_PHRASE'],
                 rsa_private_key = 'private.pem',
                 rsa_public_key = 'public.pem')
    # openssl genrsa -des3 -out private.pem 2048 # 256..2048
    # openssl rsa -in private.pem -out public.pem -outform PEM -pubout
    @rsa_pass_phrase = rsa_pass_phrase
    @rsa_private_key = File.read rsa_private_key
    @rsa_public_key = File.read rsa_public_key
  end

  def encrypt(data)
    # AES: encrypt the data
    cipher = OpenSSL::Cipher.new('AES-128-CBC')
    cipher.encrypt
    key = cipher.random_key
    iv = cipher.iv = Time.now.to_f.to_s[0, 16] # length must be 16 bytes = 128 bits

    encrypted_data = Base64.encode64(cipher.update(data) + cipher.final)

    # RSA: encrypt the AES key
    public_key = OpenSSL::PKey::RSA.new(@rsa_public_key)
    encrypted_key = Base64.encode64(public_key.public_encrypt(key))
    encrypted_iv = Base64.encode64(public_key.public_encrypt(iv))

    [encrypted_data, encrypted_key, encrypted_iv].join(',')
  end

  def decrypt(encrypted_string, drift = 5)
    return nil unless valid?(encrypted_string)

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
    return nil if Time.now.to_i - decrypted_iv.to_i > drift


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