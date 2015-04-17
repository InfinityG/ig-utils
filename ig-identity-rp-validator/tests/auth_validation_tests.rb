require 'minitest'
require 'minitest/autorun'
require 'json'

require_relative '../lib/ig-identity-rp-validator'

class AuthValidationTests< MiniTest::Test

  def test_auth_validates_successfully

    shared_aes_key = 'ky4xgi0+KvLYmVp1J5akqkJkv8z5rJsHTo9FcBc0hgo='
    public_ecdsa_key = 'A1blXQkf5AH7pfNNx2MIwNXytCyV/wxmQOt7ZGgccvVQ'

    auth = JSON.parse('{"auth":"kPBYy7DI9IyVcIoiu0Xmc4gE0DFU7rsKydoAffpVjbfBN6o8/lba1mFFYQRU\njHk6eWO3+i/idZ/kKaUpdEhjlsOWKWEoEJlPbjBNvzYuGnNetmeBvuZE6ZL/\nR8zrHv4kxihDl6x02bPcpm7C7EYWrx+2BWmSI3WqlUiXw03G9kV8ReEKqZv3\nWAfMo3wZ2f8yVkzD4tt6Sv0M9h1aQ+UUQlizspIJ0a9tuXWe5nN8P2TbuCtN\ndByFXQEIGZMVyUeNHq4krGHONKBCWCo6fsjokOQ8nfKOSh9VWKr0r/tgyMKq\nAf7cQziEBf6L26XzDdtiGpecoOO/s76MCUyC58kcS6/4JTII2pUxEbQ9KYw7\nxvFwq6SeP8z34Qr0rFOH2I3SvS12snQ5u0q/1T0w5VZ0mJjLFE0l8zal+BTz\nysjPkby/Wn4WMII5OxI5wKMO7YG2uR2RLcTNIeve9l3Ztn65LBSsIdXCUEoI\nn8rQrYAdfTo0AkZnzEy//wW6h2UeW+rnDBZBIFIrsymMb26ZpDria21+ku7B\nBY+8pwDPeIhL1xU=\n","iv":"N5B62v/0oZbBKXGiX1sC4Q==\n"}', :symbolize_names => true)

    result = IgIdentity::RelyingParty::AuthValidator.new.validate_auth(auth[:auth], auth[:iv], shared_aes_key, public_ecdsa_key)

    assert result[:valid]

  end

  def test_auth_fails_when_invalid_auth

    shared_aes_key = 'ky4xgi0+KvLYmVp1J5akqkJkv8z5rJsHTo9FcBc0hgo='
    public_ecdsa_key = 'A1blXQkf5AH7pfNNx2MIwNXytCyV/wxmQOt7ZGgccvVQ'

    auth = JSON.parse('{"auth":"sdsdfsdfsdfsdfsdfsfsdfsdfsdfsdfsdfsd","iv":"N5B62v/0oZbBKXGiX1sC4Q==\n"}', :symbolize_names => true)

    result = IgIdentity::RelyingParty::AuthValidator.new.validate_auth(auth[:auth], auth[:iv], shared_aes_key, public_ecdsa_key)

    assert !result[:valid]

  end
end