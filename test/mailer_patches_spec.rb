# If defined, ALAVETELI_TEST_THEME will be loaded in config/initializers/theme_loader
ALAVETELI_TEST_THEME = 'panama-theme'
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','spec','spec_helper'))

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
    @ir.date_nearly_overdue_by.strftime("%F").should == '2007-10-24'
  end
end

describe RequestMailer, " when sending nearly overdue alerts to public bodies" do

  before do
    # Stub this so that we're definitely using calendar days based calculations
    # rather than working days, so that setting up test fixture requests with
    # appropriate dates to trigger alerts doesn't make me go insane.
    AlaveteliConfiguration.stub!(:working_or_calendar_days).and_return('calendar')
  end

  before(:each) do
    user = User.first
    public_body = PublicBody.first
    second_public_body = PublicBody.last

    Time.stub!(:now).and_return(Time.utc(2014, 07, 31, 0, 0, 0))
    @new_info_request = FactoryGirl.create(:info_request,
                                           :title => "A new request",
                                           :user => user,
                                           :public_body => public_body)

    Time.stub!(:now).and_return(Time.utc(2014, 07, 20, 0, 0, 0))
    @nearly_overdue_info_request = FactoryGirl.create(:info_request,
                                                      :title => "A nearly overdue request",
                                                      :user => user,
                                                      :public_body => public_body)

    Time.stub!(:now).and_return(Time.utc(2014, 07, 10, 0, 0, 0))
    @overdue_info_request = FactoryGirl.create(:info_request,
                                               :title => "An overdue request",
                                               :user => user,
                                               :public_body => second_public_body)

    Time.stub!(:now).and_return(Time.utc(2014, 06, 20, 0, 0, 0))
    @very_overdue_info_request = FactoryGirl.create(:info_request,
                                                    :title => "A very overdue request",
                                                    :user => user,
                                                    :public_body => public_body)

    Time.stub!(:now).and_return(Time.utc(2014, 07, 31, 0, 0, 0))

    # Creating these requests creates mails, we don't care about them
    ActionMailer::Base.deliveries.clear
  end

  after do
    AlaveteliConfiguration.unstub!(:working_or_calendar_days)
    Time.unstub!(:now)
  end

  it "only sends alerts about nearly overdue problems" do
    RequestMailer.should_receive(:body_nearing_overdue_alert) \
                 .with(@nearly_overdue_info_request) \
                 .and_call_original
    RequestMailer.alert_body_nearing_overdue_requests
  end

  it "sends alerts to the request body" do
    RequestMailer.alert_body_nearing_overdue_requests
    email = ActionMailer::Base.deliveries.first
    assert_equal [@nearly_overdue_info_request.public_body.request_email], email.to
  end

  it "records the alerts it's sent" do
    RequestMailer.alert_body_nearing_overdue_requests
    sent_alert = BodyInfoRequestSentAlert.find_by_info_request_id(@nearly_overdue_info_request.id)
    assert_equal 'nearing_overdue_1', sent_alert.alert_type
  end

  it "doesn't send alerts twice" do
    RequestMailer.alert_body_nearing_overdue_requests
    RequestMailer.alert_body_nearing_overdue_requests
    assert_equal 1, ActionMailer::Base.deliveries.length
  end

  it "skips over errors with requests" do
    # Requests with malformed body emails might never have been sent anywhere
    # and that will cause an error when we process them because our check of
    # event id's will return nil. Stub that to make it happen in this test
    InfoRequest.any_instance.stub(:last_event_forming_initial_request).and_return(nil)
    RequestMailer.alert_body_nearing_overdue_requests
    # Should not blow up
  end
end