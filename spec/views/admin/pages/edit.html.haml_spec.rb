require File.dirname(__FILE__) + '/../../../spec_helper'

describe "admin/pages/edit.html.haml" do
  dataset :users, :pages
  
  before(:each) do
    @main = mock_model(Main)
    assigns[:main] = @main
  end
  
  it "should display a date selector for event start" do
    render "admin/pages/edit.html.haml"
    response.should have_selector("select",
      :name => "page[event_start(1i)]")
  end

  it "should display a date selector for event end"  
end
