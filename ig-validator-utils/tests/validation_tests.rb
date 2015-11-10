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

  def test_mobile_pass
    numbers = ['+27 12345678', '+2712345678', '+44 9987654324', '+449987654324']
    numbers.each do |number|
      assert ValidatorUtils::GeneralValidator.validate_mobile(number)
    end
  end

  def test_mobile_fail
    numbers = ['012345678', '0712345678', '9987654324', '+44998765432490809809809980']
    numbers.each do |number|
      assert !ValidatorUtils::GeneralValidator.validate_mobile(number)
    end
  end

  def test_address_pass_1
    address = '12 ajax way, cape town 2012'
    assert ValidatorUtils::GeneralValidator.validate_address address
    end

  def test_address_pass_2
    address = '12 ajax way, cape-town 2012'
    assert ValidatorUtils::GeneralValidator.validate_address address
  end

  def test_address_fail_1
    address = '12 ajax way, cape town 2012 %'
    assert !ValidatorUtils::GeneralValidator.validate_address(address)
  end

  def test_address_fail_2
    address = '12 ajax way, cape town 2012 >'
    assert !ValidatorUtils::GeneralValidator.validate_address(address)
    end

  def test_address_fail_3
    address = '& 12 ajax way, cape town 2012'
    assert !ValidatorUtils::GeneralValidator.validate_address(address)
    end

  def alpha_numeric_pass_1
    val = 'g1jk2h3gh123jk'
    assert ValidatorUtils::GeneralValidator.validate_alpha_numeric(val)
    end

  def alpha_numeric_pass_2
    val = '131231231231'
    assert ValidatorUtils::GeneralValidator.validate_alpha_numeric(val)
    end

  def alpha_numeric_pass_3
    val = 'jsdhasdkhklsh'
    assert ValidatorUtils::GeneralValidator.validate_alpha_numeric(val)
    end

  def alpha_numeric_fail_1
    val = 'lkjh£33'
    assert !ValidatorUtils::GeneralValidator.validate_alpha_numeric(val)
  end

end