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
