module Eventful::PagesControllerExtensions
  def update_event_ui
    current_page = Page.new(params[:page])
    @page = Page.find(params[:id])
    @page.all_day_event = current_page.all_day_event
    @page.no_end_time = current_page.no_end_time
    render :partial => "event_dates_dynamic", :object => @page
  end
end