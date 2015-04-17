require 'minitest'
require 'minitest/autorun'
require 'base64'

require_relative '../../ig-crypto-utils/lib/ig-crypto-utils'

class EcdsaTests < MiniTest::Test

  def test_create_key_pair
    result = CryptoUtils::EcdsaUtil.new.create_key_pair

    assert result[:pk]!= nil
    assert result[:sk]!= nil
  end

  def test_sign
    text = 'Text to sign'
    text_digest = CryptoUtils.create_digest text
    encoded_text_digest = Base64.encode64 text_digest

    encoded_secret_key = 'gCrHtl8VVWs6EuJLy7vPqVdBZWzRAR9ZCjIRRpoWvME=' # already base64 encoded
    encoded_public_key = 'Ag7PunGy2BmnAi+PGE4/Dm9nCg1URv8wLZwSOggyfmAn' # already base64 encoded

    util = CryptoUtils::EcdsaUtil.new

    # sign
    encoded_result = util.sign encoded_text_digest, encoded_secret_key

    # validate
    validation_result = util.validate_signature encoded_text_digest, encoded_result, encoded_public_key

    puts validation_result
    assert validation_result

  end
end