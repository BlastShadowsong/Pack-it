require 'openssl'
require 'base64'

class HybridCrypt

  def initialize(rsa_public_key = ENV['RSA_PUBLIC_KEY'],
                 rsa_private_key = ENV['RSA_PRIVATE_KEY'],
                 rsa_pass_phrase = ENV['RSA_PASS_PHRASE'])
    # openssl genrsa -des3 -out private.pem 2048 # 256..2048
    # openssl rsa -in private.pem -out public.pem -outform PEM -pubout
    @rsa_public_key = rsa_public_key
    @rsa_private_key = rsa_private_key
    @rsa_pass_phrase = rsa_pass_phrase
  end

  def encrypt(data, use_iv = false)
    # AES: encrypt the data
    cipher = OpenSSL::Cipher.new('AES-128-CBC')
    cipher.encrypt
    key = cipher.random_key
    iv = cipher.random_iv if use_iv

    encrypted_data = Base64.encode64(cipher.update(data) + cipher.final)

    # RSA: encrypt the AES key
    public_key = OpenSSL::PKey::RSA.new(@rsa_public_key)
    encrypted_key = Base64.encode64(public_key.public_encrypt(key))
    encrypted_iv = Base64.encode64(public_key.public_encrypt(iv)) if iv

    [encrypted_data, encrypted_key, encrypted_iv].reject { |el| el.nil? }.join(',')
  end

  def decrypt(encrypted_data_key_iv)
    return encrypted_data_key_iv unless encrypted_data_key_iv.include?(',')

    # [data, key, iv]
    encrypted_ary = encrypted_data_key_iv.split(',')
    encrypted_data = encrypted_ary[0]
    encrypted_key = encrypted_ary[1]
    encrypted_iv = encrypted_ary[2] if encrypted_ary.size > 2 # iv is optional

    # RSA: decrypt the AES key
    private_key = OpenSSL::PKey::RSA.new(@rsa_private_key, @rsa_pass_phrase)
    decrypted_key = private_key.private_decrypt(Base64.decode64(encrypted_key))
    decrypted_iv = private_key.private_decrypt(Base64.decode64(encrypted_iv)) if encrypted_iv

    # AES: decrypt the data
    decipher = OpenSSL::Cipher.new('AES-128-CBC')
    decipher.decrypt
    decipher.key = decrypted_key
    decipher.iv = decrypted_iv if decrypted_iv

    decipher.update(Base64.decode64(encrypted_data)) + decipher.final
  end
end