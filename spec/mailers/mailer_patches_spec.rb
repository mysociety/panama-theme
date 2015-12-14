# If defined, ALAVETELI_TEST_THEME will be loaded in config/initializers/theme_loader
ALAVETELI_TEST_THEME = 'panama-theme'
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','..','spec','spec_helper'))

describe RequestMailer, " when sending nearly overdue alerts to public bodies" do

  before do
    # Stub this so that we're definitely using calendar days based calculations
    # rather than working days, so that setting up test fixture requests with
    # appropriate dates to trigger alerts doesn't make me go insane.
    allow(AlaveteliConfiguration).to receive(:working_or_calendar_days).and_return('calendar')
  end

  before(:each) do
    user = User.first
    # We need to add some more Panama-specific details to this user
    user.address = "Test street, test town, testville"
    public_body = PublicBody.first
    second_public_body = PublicBody.last

    allow(Time).to receive(:now).and_return(Time.utc(2014, 07, 31, 0, 0, 0))

    @new_info_request = FactoryGirl.create(:info_request,
                                           :title => "A new request",
                                           :user => user,
                                           :public_body => public_body)


    allow(Time).to receive(:now).and_return(Time.utc(2014, 07, 20, 0, 0, 0))
    @nearly_overdue_info_request = FactoryGirl.create(:info_request,
                                                      :title => "A nearly overdue request",
                                                      :user => user,
                                                      :public_body => public_body)

    allow(Time).to receive(:now).and_return(Time.utc(2014, 07, 10, 0, 0, 0))
    @overdue_info_request = FactoryGirl.create(:info_request,
                                               :title => "An overdue request",
                                               :user => user,
                                               :public_body => second_public_body)

    allow(Time).to receive(:now).and_return(Time.utc(2014, 06, 20, 0, 0, 0))
    @very_overdue_info_request = FactoryGirl.create(:info_request,
                                                    :title => "A very overdue request",
                                                    :user => user,
                                                    :public_body => public_body)

    allow(Time).to receive(:now).and_return(Time.utc(2014, 07, 31, 0, 0, 0))

    # Creating these requests creates mails, we don't care about them
    ActionMailer::Base.deliveries.clear
  end

  it "only sends alerts about nearly overdue problems" do
    expect(RequestMailer).to receive(:body_nearing_overdue_alert) \
                         .with(@nearly_overdue_info_request) \
                         .and_call_original
    RequestMailer.alert_body_nearing_overdue_requests
  end

  it "sends alerts to the request body" do
    RequestMailer.alert_body_nearing_overdue_requests
    email = ActionMailer::Base.deliveries.first
    expect([@nearly_overdue_info_request.public_body.request_email]).to eq(email.to)
  end

  it "records the alerts it's sent" do
    RequestMailer.alert_body_nearing_overdue_requests
    sent_alert = BodyInfoRequestSentAlert.find_by_info_request_id(@nearly_overdue_info_request.id)
    expect(sent_alert.alert_type).to eq('nearing_overdue_1')
  end

  it "doesn't send alerts twice" do
    RequestMailer.alert_body_nearing_overdue_requests
    RequestMailer.alert_body_nearing_overdue_requests
    expect(ActionMailer::Base.deliveries.length).to eq(1)
  end

  it "skips over errors with requests" do
    # Requests with malformed body emails might never have been sent anywhere
    # and that will cause an error when we process them because our check of
    # event id's will return nil. Stub that to make it happen in this test
    allow(InfoRequest).to receive(:last_event_forming_initial_request).and_return(nil)
    RequestMailer.alert_body_nearing_overdue_requests
    # Should not blow up
  end
end

describe RequestMailer, " when sending overdue alerts to public bodies" do

  before do
    # Stub this so that we're definitely using calendar days based calculations
    # rather than working days, so that setting up test fixture requests with
    # appropriate dates to trigger alerts doesn't make me go insane.
    allow(AlaveteliConfiguration).to receive(:working_or_calendar_days).and_return('calendar')
  end

  before(:each) do
    user = User.first
    # We need to add some more Panama-specific details to this user
    user.address = "Test street, test town, testville"
    public_body = PublicBody.first
    second_public_body = PublicBody.last

    allow(Time).to receive(:now).and_return(Time.utc(2014, 07, 31, 0, 0, 0))

    @new_info_request = FactoryGirl.create(:info_request,
                                           :title => "A new request",
                                           :user => user,
                                           :public_body => public_body)


    allow(Time).to receive(:now).and_return(Time.utc(2014, 07, 20, 0, 0, 0))
    @nearly_overdue_info_request = FactoryGirl.create(:info_request,
                                                      :title => "A nearly overdue request",
                                                      :user => user,
                                                      :public_body => public_body)

    allow(Time).to receive(:now).and_return(Time.utc(2014, 07, 10, 0, 0, 0))
    @overdue_info_request = FactoryGirl.create(:info_request,
                                               :title => "An overdue request",
                                               :user => user,
                                               :public_body => second_public_body)

    allow(Time).to receive(:now).and_return(Time.utc(2014, 06, 20, 0, 0, 0))
    @very_overdue_info_request = FactoryGirl.create(:info_request,
                                                    :title => "A very overdue request",
                                                    :user => user,
                                                    :public_body => public_body)

    allow(Time).to receive(:now).and_return(Time.utc(2014, 07, 31, 0, 0, 0))

    # Creating these requests creates mails, we don't care about them
    ActionMailer::Base.deliveries.clear
  end

  it "only sends alerts about overdue problems" do
    expect(RequestMailer).to receive(:body_overdue_alert) \
                         .with(@overdue_info_request) \
                         .and_call_original
    RequestMailer.alert_body_overdue_requests
  end

  it "sends alerts to the request body" do
    RequestMailer.alert_body_overdue_requests
    email = ActionMailer::Base.deliveries.first
    expect([@overdue_info_request.public_body.request_email]).to eq(email.to)
  end

  it "records the alerts it's sent" do
    RequestMailer.alert_body_overdue_requests
    sent_alert = BodyInfoRequestSentAlert.find_by_info_request_id(@overdue_info_request.id)
    expect(sent_alert.alert_type).to eq('overdue_1')
  end

  it "doesn't send alerts twice" do
    RequestMailer.alert_body_overdue_requests
    RequestMailer.alert_body_overdue_requests
    expect(ActionMailer::Base.deliveries.length).to eq(1)
  end

  it "skips over errors with requests" do
    # Requests with malformed body emails might never have been sent anywhere
    # and that will cause an error when we process them because our check of
    # event id's will return nil. Stub that to make it happen in this test
    allow(InfoRequest).to receive(:last_event_forming_initial_request).and_return(nil)
    RequestMailer.alert_body_overdue_requests
    # Should not blow up
  end
end