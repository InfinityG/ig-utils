require 'minitest'
require 'minitest/autorun'
require 'base64'

require_relative '../../ig-crypto-utils/lib/ig-crypto-utils'

class AesTests < MiniTest::Test

  def test_encrypt
    # NOTE: AesUtil methods expect all inputs to be Base64 encoded

    util = CryptoUtils::AesUtil.new

    plain_text = '{"blah":"Super secret text"}'
    encoded_plain_text = Base64.encode64 plain_text

    aes_256_key = 'ky4xgi0+KvLYmVp1J5akqkJkv8z5rJsHTo9FcBc0hgo='  # already base64 encoded

    # encrypt
    encrypted_result = util.encrypt encoded_plain_text, aes_256_key

    # decrypt
    decrypted_result = util.decrypt encrypted_result[:cipher_text], aes_256_key, encrypted_result[:iv]

    assert decrypted_result == encoded_plain_text
  end
end