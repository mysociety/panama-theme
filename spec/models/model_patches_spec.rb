# If defined, ALAVETELI_TEST_THEME will be loaded in config/initializers/theme_loader
ALAVETELI_TEST_THEME = 'panama-theme'
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','..','spec','spec_helper'))

describe User do
  it "can create business users" do
    user = User.new(
        {
            :user_type => "business",
            :company_name => "Fake Company",
            :company_number => "1234",
            :phone_number => "1234567",
            :incorporation_date => Date.parse("2014-08-08")
        }
    )
    expect(user.company_name).to eq("Fake Company")
    expect(user.is_company?).to be_true

    user.save
    expect(user.errors.messages.keys).to eq([:email, :name, :hashed_password])
  end

  it "can create individual users" do
    user = User.new(
        {
            :user_type => "individual",
            :phone_number => "1234567",
            :address => "1 Long Road",
            :national_id_number => "1"
        }
    )
    expect(user.national_id_number).to eq("1")
    expect(user.is_individual?).to be_true

    user.save
    expect(user.errors.messages.keys).to eq([:email, :name, :hashed_password])
  end

  it "missing fields for individuals creates errors" do
    user = User.new(
        {
            :user_type => "individual"
        }
    )
    user.save
    expect(user.errors.messages.keys.include?(:phone_number)).to be_true
    expect(user.errors.messages.keys.include?(:address)).to be_true
    expect(user.errors.messages.keys.include?(:national_id_number)).to be_true
  end

  it "missing fields for businesses creates errors" do
    user = User.new(
        {
            :user_type => "business"
        }
    )
    user.save
    expect(user.errors.messages.keys.include?(:phone_number)).to be_true
    expect(user.errors.messages.keys.include?(:company_name)).to be_true
    expect(user.errors.messages.keys.include?(:company_number)).to be_true
    expect(user.errors.messages.keys.include?(:incorporation_date)).to be_true
  end

  it "user_type should default to individual" do
    user = User.new
    expect(user.user_type).to eq('individual')
  end
end

describe BodyInfoRequestSentAlert do
  before(:each) do
    @public_body = mock_model(PublicBody)
    @info_request = mock_model(InfoRequest)
    @info_request_event = mock_model(InfoRequestEvent)
  end

  it "can create a body info_request sent alert" do
    sent_alert = BodyInfoRequestSentAlert.new
    sent_alert.info_request = @info_request
    sent_alert.public_body = @public_body
    sent_alert.info_request_event = @info_request_event
    sent_alert.alert_type = 'nearing_overdue_1'
    sent_alert.save!
  end
end

describe InfoRequest, " when patched to add a date_nearly_overdue_by method" do
  before do
    @ir = info_requests(:naughty_chicken_request)
    AlaveteliConfiguration.stub!(:working_or_calendar_days).and_return('calendar')
    AlaveteliConfiguration.stub!(:reply_nearly_late_after_days).and_return(10)
  end

  after do
    AlaveteliConfiguration.unstub!(:working_or_calendar_days)
    AlaveteliConfiguration.unstub!(:reply_nearly_late_after_days)
  end

  it "has correct nearly due date" do
    # This assumes that we're set to calendar days above, and that replies are
    # "nearly" late after 10 days, hence the stubbing of config values in
    # before to make that guaranteed
    expect(@ir.date_nearly_overdue_by.strftime("%F")).to eq('2007-10-24')
  end
end

describe InfoRequest, " when patched to remove mixed case validation" do
  it "allows all lower-case titles" do
    request = InfoRequest.new(
      :title => 'all lower case',
      :public_body_id => 2,
      :user_id => 1
    )
    expect(request).to be_valid
  end
end