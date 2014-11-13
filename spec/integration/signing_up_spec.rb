# If defined, ALAVETELI_TEST_THEME will be loaded in config/initializers/theme_loader
ALAVETELI_TEST_THEME = 'panama-theme'
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','..','spec','spec_helper'))

describe "Signing up" do
  it "Should allow me to sign up as an individual" do
    visit '/profile/sign_in'

    fill_in "user_signup[email]", :with => "test@example.com"
    fill_in "user_signup[name]", :with => "Test User"
    fill_in "user_signup[phone_number]", :with => "123456789"
    choose "Individual"
    fill_in "user_signup[address]", :with => "1, street, town, country, POSTCODE"
    fill_in "user_signup[national_id_number]", :with => "aabc123456789"
    fill_in "user_signup[password]", :with => 'password'
    fill_in "user_signup[password_confirmation]", :with => 'password'

    click_button "Sign up"

    assert_contain("Now check your email")

    expect(User.where(:email => "test@example.com",
                      :user_type => 'individual',
                      :phone_number => '123456789',
                      :national_id_number => 'aabc123456789',
                      :address => '1, street, town, country, POSTCODE')).to exist
  end

  it "Should allow me to sign up as a business" do
    visit '/profile/sign_in'

    fill_in "user_signup[email]", :with => "test@example.com"
    fill_in "user_signup[name]", :with => "Test User"
    fill_in "user_signup[phone_number]", :with => "123456789"
    choose "Legal person"
    fill_in "user_signup[company_name]", :with => "Company"
    fill_in "user_signup[company_number]", :with => "aabc123456789"
    fill_in "user_signup[incorporation_date]", :with => '01/01/2000'
    fill_in "user_signup[password]", :with => 'password'
    fill_in "user_signup[password_confirmation]", :with => 'password'

    click_button "Sign up"

    assert_contain("Now check your email")

    expect(User.where(:email => "test@example.com",
                      :user_type => 'business',
                      :company_name => 'Company',
                      :company_number => 'aabc123456789',
                      :incorporation_date => '2000-01-01')).to exist
  end
end