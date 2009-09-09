require File.dirname(__FILE__) + '/../../../spec_helper'

describe "admin/pages/edit.html.haml" do
  dataset :event_pages
  
  before(:each) do
    @page = @model = event_pages(:normal_page)
  end
  
  it "should display a date selector for event start" do
    render "admin/pages/edit.html.haml"
    response.should have_selector("select",
      :name => "page[event_start(1i)]")
  end

  it "should display a date selector for event end" do
    render "admin/pages/edit.html.haml"
    response.should have_selector("select",
      :name => "page[event_end(1i)]")
  end
end
