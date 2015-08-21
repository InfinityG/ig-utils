require 'ig-crypto-utils'
require 'base64'
require 'json'

module IgIdentity

  module RelyingParty

    class AuthValidator

      # 1. decrypt the auth payload using shared AES key + iv
      # 2. validate the signature using ecdsa_secret_key
      # 3. parse the username and role (and ip address if present) from the payload
      # 4. parse the expiry date from the payload and check if expired
      # 5. if all valid, generate response of the form {:valid => true, :auth => {...}}
      def validate_auth(auth, iv, aes_key, ecdsa_public_key)

        begin
          decrypted_result = Base64.decode64 CryptoUtils::AesUtil.new.decrypt(auth, aes_key, iv)
          parsed_result = JSON.parse(decrypted_result, :symbolize_names => true)

          digest = parsed_result[:digest]
          signature = parsed_result[:signature]

          # validate the signature
          return {:valid => true, :auth => parsed_result} if
              CryptoUtils::EcdsaUtil.new.validate_signature(digest, signature, ecdsa_public_key)

          {:valid => false, auth: nil}

        rescue
          {:valid => false, auth: nil}
        end

      end

    end

  end

end