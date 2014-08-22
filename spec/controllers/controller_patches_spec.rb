# If defined, ALAVETELI_TEST_THEME will be loaded in config/initializers/theme_loader
ALAVETELI_TEST_THEME = 'panama-theme'
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','..','spec','spec_helper'))

describe UserController do

  before(:each) do
    controller.stub(:authenticated?).and_return(true)
  end

  it "should get signchangeaddress" do
    get :signchangeaddress
    expect(response.status).to eq(200)
  end

  it "should get signchangenationalid" do
    get :signchangenationalid
    expect(response.status).to eq(200)
  end

  it "should get signchangephone" do
    get :signchangephone
    expect(response.status).to eq(200)
  end

  it "should get signchangecompanyname" do
    get :signchangecompanyname
    expect(response.status).to eq(200)
  end

  it "should get signchangecompanynumber" do
    get :signchangecompanynumber
    expect(response.status).to eq(200)
  end

  it "should get signchangecompanyincdate" do
    get :signchangecompanyincdate
    expect(response.status).to eq(200)
  end
end

describe AdminGeneralController, "when the stats action is patched" do
  before(:each) do
    controller.stub(:authenticated?).and_return(true)
  end

  it "should add the datestamp of the first request into the context" do
    get :stats
    expect(assigns(:first_request_datetime)).to eq InfoRequest.minimum(:created_at)
  end
end

describe AdminGeneralController, "when generating a stats csv" do
  before(:each) do
    controller.stub(:authenticated?).and_return(true)
  end

  it "should generate the correct csv" do
    response = get :stats_monthly_transactions_csv, :date => {:start_year => "2006",
                                                   :start_month => "1",
                                                   :end_year => "2006",
                                                   :end_month => "1"}
    expected_csv = <<EOD
Period,Requests sent,Annotations added,Track this request email signups,Comments on own requests,Follow up messages sent
2006-01-01-2006-01-31,2,0,0,0,0
EOD
    expect(response.body).to eq(expected_csv)
  end
end
