require 'minitest'
require 'minitest/autorun'

require_relative '../../ig-validator-utils/lib/ig-validator-utils'

class ValidationTests < MiniTest::Test

  def test_boolean_true
    val = true
    assert ValidatorUtils::GeneralValidator.validate_boolean val
    end

  def test_boolean_false
    val = false
    assert ValidatorUtils::GeneralValidator.validate_boolean val
    end

  def test_boolean_fail
    val = 'sdasd'
    assert !ValidatorUtils::GeneralValidator.validate_boolean(val)
    end

  def test_uri_pass
    val = 'http://www.bob.com/test'
    assert ValidatorUtils::GeneralValidator.validate_uri(val)
    end

  def test_uri_pass_with_querystring
    val = 'http://www.bob.com/test?foo=bar'
    assert ValidatorUtils::GeneralValidator.validate_uri(val)
  end

  def test_nonsense_uri_fail
    val = 'sjashdahlaksdladh'
    assert !ValidatorUtils::GeneralValidator.validate_uri(val)
    end

  def test_uri_fail_with_no_protocol
    val = 'www.bob.com/test'
    assert !ValidatorUtils::GeneralValidator.validate_uri(val)
    end

  def test_uri_fail_with_malformed_protocol
    val = 'htp://www.bob.com/test'
    assert !ValidatorUtils::GeneralValidator.validate_uri(val)
    end

  def test_email_pass
    val = 'bob@builder.com'
    assert ValidatorUtils::GeneralValidator.validate_email(val)
    end

  def test_email_fail_with_missing_at
    val = 'bobbuilder.com'
    assert !ValidatorUtils::GeneralValidator.validate_email(val)
    end

  def test_email_fail_with_missing_prefix
    val = '@builder.com'
    assert !ValidatorUtils::GeneralValidator.validate_email(val)
    end

  def test_email_fail_with_missing_suffix
    val = 'bob@.com'
    assert !ValidatorUtils::GeneralValidator.validate_email(val)
  end

  def test_email_fail_with_missing_domain
    val = 'bob@builder.'
    assert !ValidatorUtils::GeneralValidator.validate_email(val)
    end

end