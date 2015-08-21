require 'securerandom'
require 'digest'
require 'base64'
require 'openssl'

# NOTE: All inputs of methods in this module require Base64 encoding!
# Outputs are all Base64 encoded

module CryptoUtils

  # General use static functions

  def self.encode_base64(value)
    unless value =~ /^([A-Za-z0-9+]{4})*([A-Za-z0-9+]{4}|[A-Za-z0-9+]{3}=|[A-Za-z0-9+]{2}==)$/i
      puts "#{value} is NOT base64 encoded, ENCODING..."
      return Base64.encode64 value
    end

    value
  end

  def self.decode_base64(value)
    if value =~ /^([A-Za-z0-9+]{4})*([A-Za-z0-9+]{4}|[A-Za-z0-9+]{3}=|[A-Za-z0-9+]{2}==)$/i
      puts "#{value} is base64 encoded, ...DECODING"
      return Base64.decode64 value
    end

    value
  end

  def self.create_digest(value)
    Digest::SHA2.base64digest value
    end

  def self.create_random_aes_key()
    Digest::SHA2.base64digest value
  end

  #############################
  # SYMMETRIC ENCRYPTION UTIL
  #############################

  class AesUtil
    # https://gist.github.com/byu/99651
    # http://ruby-doc.org/stdlib-1.9.3/libdoc/openssl/rdoc/OpenSSL/Cipher.html

    # use this to generate a random (base64 encoded) AES key if required
    def generate_random_encoded_aes_key
      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.encrypt
      Base64.encode64 cipher.random_key
    end

    def encrypt(encoded_plain_text, encoded_key)

      cipher = OpenSSL::Cipher::AES.new(256, :CBC) # CBC = cipher block chaining
      cipher.encrypt

      # generate a random iv
      iv = cipher.random_iv

      cipher.key = encoded_key
      cipher.iv = iv

      result = cipher.update(encoded_plain_text) + cipher.final

      encoded_result = Base64.encode64 result
      encoded_iv = Base64.encode64 iv

      {:cipher_text => encoded_result, :iv => encoded_iv}
    end

    def decrypt(encoded_cipher_text, encoded_key, encoded_iv)

      decoded_cipher_text = Base64.decode64 encoded_cipher_text
      decoded_iv = Base64.decode64 encoded_iv

      cipher = OpenSSL::Cipher::AES.new(256, :CBC)
      cipher.decrypt

      cipher.key = encoded_key
      cipher.iv = decoded_iv

      cipher.update(decoded_cipher_text) + cipher.final
    end

  end

  ##########################
  # ASYMMETRIC SIGNING UTIL
  ##########################

  class EcdsaUtil

    # for a 256-bit ECDSA curve, the uncompressed pubkey is 512 bits (256 bits of x, 256 bits of y, no sign bit).
    # The compressed pubkey is 257 bits (256 bits of x, one bit of the sign of y).
    def create_key_pair
      group_name = 'secp256k1'

      # set compression to true for key generation on the group
      group = OpenSSL::PKey::EC::Group.new(group_name)
      group.point_conversion_form = :compressed

      # instantiate the curve and generate the keys
      curve = OpenSSL::PKey::EC.new(group)
      curve.generate_key

      public_key = curve.public_key
      private_key = curve.private_key

      # get binary representation of keys
      pk_bn_bin = public_key.to_bn.to_s(2)
      sk_bn_bin = private_key.to_s(2)

      #base64 encode keys
      encoded_pk = Base64.encode64(pk_bn_bin)
      encoded_sk = Base64.encode64(sk_bn_bin)

      {:pk => encoded_pk, :sk => encoded_sk}

    end

    def sign(encoded_data, encoded_private_key)
      group_name = 'secp256k1'

      decoded_data = Base64.decode64 encoded_data
      decoded_private_key = Base64.decode64 encoded_private_key

      curve = OpenSSL::PKey::EC.new(group_name)
      curve.private_key = OpenSSL::BN.new(decoded_private_key, 2)

      result = curve.dsa_sign_asn1 decoded_data

      Base64.encode64 result
    end

    def validate_signature(encoded_digest, encoded_signature, encoded_public_key)
      group_name = 'secp256k1'

      decoded_signature = Base64.decode64 encoded_signature
      decoded_digest = Base64.decode64 encoded_digest
      decoded_public_key = Base64.decode64 encoded_public_key

      curve = OpenSSL::PKey::EC.new(group_name)
      key_bn = OpenSSL::BN.new(decoded_public_key, 2)
      group = OpenSSL::PKey::EC::Group.new(group_name)
      curve.public_key = OpenSSL::PKey::EC::Point.new(group, key_bn)

      curve.dsa_verify_asn1(decoded_digest, decoded_signature)
    end
  end

end