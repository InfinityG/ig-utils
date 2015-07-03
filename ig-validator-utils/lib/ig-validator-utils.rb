module ValidatorUtils
  class GeneralValidator
    def self.validate_string(value)
      value.to_s != ''
    end

    # \p{L} matches a single unicode letter
    # also allows '.', '-', '_', '@'
    # takes into account usernames that are email addresses
    def self.validate_username_strict(value)
      value =~ /^[\p{L} .-@_]+$/i
    end

    # \p{L} matches a single unicode letter
    # also allows points, apostrophe and hyphen
    def self.validate_string_strict(value)
      value =~ /^[\p{L} .'-]+$/i
    end

    def self.validate_integer(value)
      Float(value) != nil rescue false
    end

    def self.validate_uuid(value)
      value =~ /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
    end

    def self.validate_hex(value)
      value =~ /^[a-f\d]{24}$/i
    end

    # At least one upper case letter
    # At least one lower case letter
    # At least one digit
    # Minimum 6 in length
    # Maximum 12 in length
    def self.validate_password(value)
      value =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,12}$/
    end

    # for a 256-bit ECDSA curve, the uncompressed pubkey is 512 bits (256 bits of x, 256 bits of y, no sign bit).
    # the compressed pubkey is 257 bits (256 bits of x, one bit of the sign of y).
    # this equates to 32 bytes (ie: 256/8 = 32) + 1 (the sign) = 33
    def self.validate_public_ecdsa_key(value)
      decoded_key = Base64.decode64 value
      decoded_key.length == 33
    end

    def self.validate_unix_datetime(value)
      begin
        now = Date.today.to_time
        time_to_validate = Time.at value
        return time_to_validate > now
      rescue
        return false
      end
    end

    # validates base64 encoding (includes newline constants '\n')
    def self.validate_base_64(value)
      value =~ /^[A-Za-z0-9+\/=\\]+={0,3}$/
    end
  end
end