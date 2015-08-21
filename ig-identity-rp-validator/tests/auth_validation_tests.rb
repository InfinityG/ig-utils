require 'minitest'
require 'minitest/autorun'
require 'json'

require_relative '../lib/ig-identity-rp-validator'

class AuthValidationTests< MiniTest::Test

  def test_auth_validates_successfully

    shared_aes_key = 'Pomro4n7AEng/jdeOCucRcOnXok/HKgY/hzLQyuL1xM='
    public_ecdsa_key = 'A1blXQkf5AH7pfNNx2MIwNXytCyV/wxmQOt7ZGgccvVQ'

    auth = JSON.parse('{"auth":"r5+/PwNxd3W2g1zHgZbhhx9YnaqRnJDwTnWZayxNZpF4OIdBFd678IbaDOeC↵jgdV4dRktEwlnlr+AEJdtlaUuB31QTA9EeXjJU44k+0j1td8ipZBCfApR7jD↵E+ku5gAEOuU96KRx5udmWUi0+kBMAsDztlrqxvkOjHZa1iNHr79iW2mZS0bk↵Zwlj+s/M6w6SzCg51wmIWG3/wcVVZSdn00AE47wsSDjUiMvTltvaBGOmxlZ+↵dM03CfyYWzlqWrN7LiF2DTf5Nd6jpvNUsd2AeKzTLDT+MYwK6VSbmpXRO9nU↵d2p6/Ygkrbyt6sxF4azJnOIfGef37O6fLPk3Qzo8t2Ng4X5xVcBl2o9i675X↵9ps45P7PKaod6GqMnniS33hmunbsbi9ZjKQQJE5DNspSQwK6hCvxNuYRxNCD↵P7EyAaoHewAEC/D4v+FVw5wbA0OaxvjQn7eGVBGJiR2GMRHk/tRzShTjxUoF↵v7zT0VhzFTvqMr1E9/ZQNZ+x8FAWMgo2t/9leFR2ITV2jxqk1DF+8xGzSVkK↵eSfJO+9sV2HMIhYhk/aGd0l9LhVLzOYLju25wx728TTtHRr44g/9CAn/LOBp↵F3gf886A6Nki01WyLtM=\n","iv":"nCGP97yEG9TW22/Sh51I2g==\n", "token": "7a723ec5-13aa-4d00-a2ce-1be903c71082"}', :symbolize_names => true)

    result = IgIdentity::RelyingParty::AuthValidator.new.validate_auth(auth[:auth], auth[:iv], shared_aes_key, public_ecdsa_key)

    assert result[:valid]

  end

  def test_auth_fails_when_invalid_auth

    shared_aes_key = 'Pomro4n7AEng/jdeOCucRcOnXok/HKgY/hzLQyuL1xM='
    public_ecdsa_key = 'A1blXQkf5AH7pfNNx2MIwNXytCyV/wxmQOt7ZGgccvVQ'

    auth = JSON.parse('{"auth":"sdsdfsdfsdfsdfsdfsfsdfsdfsdfsdfsdfsd","iv":"N5B62v/0oZbBKXGiX1sC4Q==\n"}', :symbolize_names => true)

    result = IgIdentity::RelyingParty::AuthValidator.new.validate_auth(auth[:auth], auth[:iv], shared_aes_key, public_ecdsa_key)

    assert !result[:valid]

  end
end