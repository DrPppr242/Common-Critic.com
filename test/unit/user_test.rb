require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should require valid email address" do
    # Check format of address
    user = User.new(:email => 'this_is.not_valid', 
                    :password => 'Pass123',
                    :password_confirmation => 'Pass123')
    assert !user.save, "Created user with invalid email address"
    
    user.update_attribute(:email, 'this_is@valid.now')
    assert user.save, "Couldn't created user with valid email address"

    # Check uniqueness of address
    user2 = User.new(:email => 'this_is@valid.now',
                     :password => 'Pass123',
                     :password_confirmation => 'Pass123')
    assert !user2.save, "Created user with duplicate email address"
  end

  test "should require password confirmation" do
    user = User.new(:email => 'me@here.com',
                    :password => 'Pass123')
    assert !user.save, "Created user with out password confirmation"

    user.update_attribute(:password, 'pass')
    user.update_attribute(:password_confirmation, 'pass')
    assert !user.save, "Created user with too short password"

    user.update_attribute(:password, 'Pass1234')
    user.update_attribute(:password_confirmation, 'Pass123456')
    assert !user.save, "Created user with bad password confirmation"

    user.update_attribute(:password, 'Pass1234')
    user.update_attribute(:password_confirmation, 'Pass1234')
    assert user.save, "Couldn't create user with good password and confirmation"
  end

  test "should be able to authenticate" do
    user = User.create(:email => 'user@site.com',
                :password => 'Pass123',
                :password_confirmation => 'Pass123')

    assert !User.authenticate('joe@site.com', 'somepassword'), "Authenticated non-existent user"
    assert !User.authenticate('user@site.com', 'badpassword'), "Authenticated with bad password"
    assert_equal user, User.authenticate('user@site.com', 'Pass123'), "Wasn't able to authenticate"
  end
end
