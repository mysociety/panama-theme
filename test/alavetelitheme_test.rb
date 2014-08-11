require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class AlavetelithemeTest
    class UserModelTest < ActiveModel::TestCase
        test "can create business users" do
            user = User.new(
                {
                    :user_type => "business",
                    :company_name => "Fake Company",
                    :company_number => "1234",
                    :phone_number => "1234567",
                    :incorporation_date => Date.parse("2014-08-08")
                }
            )
            assert user.company_name == "Fake Company"
            assert user.is_company?

            user.save
            assert user.errors.messages.keys == [:email, :name, :hashed_password]
        end

        test "can create individual users" do
            user = User.new(
                {
                    :user_type => "individual",
                    :phone_number => "1234567",
                    :address => "1 Long Road",
                    :national_id_number => "1"
                }
            )
            assert user.national_id_number == "1"
            assert user.is_individual?

            user.save
            assert user.errors.messages.keys == [:email, :name, :hashed_password]
        end

        test "missing fields for individuals creates errors" do
            user = User.new(
                {
                    :user_type => "individual"
                }
            )
            user.save
            assert user.errors.messages.keys.include?(:phone_number)
            assert user.errors.messages.keys.include?(:address)
            assert user.errors.messages.keys.include?(:national_id_number)
        end

        test "missing fields for businesses creates errors" do
            user = User.new(
                {
                    :user_type => "business"
                }
            )
            user.save
            assert user.errors.messages.keys.include?(:phone_number)
            assert user.errors.messages.keys.include?(:company_name)
            assert user.errors.messages.keys.include?(:company_number)
            assert user.errors.messages.keys.include?(:incorporation_date)
        end

        test "missing user_type creates an error" do
            # may not be correct behaviour - should we default it to
            # be an indivdual requestor instead?
            user = User.new()
            user.save
            assert user.errors.messages.keys.include?(:user_type)
        end
    end

    class UserControllerTest < ActionController::TestCase
        include Rack::Test::Methods
        include ActionView::Helpers::UrlHelper
        include Rails.application.routes.url_helpers

        def app
            Rails.application
        end

        def controller
            UserController
        end

        test "should get signchangeaddress" do
            get signchangeaddress_path
            assert_response :success
        end

        test "should get signchangenationalid" do
            get signchangenationalid_path
            assert_response :success
        end

        test "should get signchangephone" do
            get signchangephone_path
            assert_response :success
        end

        test "should get signchangecompanyname" do
            get signchangecompanyname_path
            assert_response :success
        end

        test "should get signchangecompanynumber" do
            get signchangecompanynumber_path
            assert_response :success
        end

        test "should get signchangeincdate" do
            get signchangeincdate_path
            assert_response :success
        end
    end

end
