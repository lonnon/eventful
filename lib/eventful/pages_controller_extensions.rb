module Eventful::PagesControllerExtensions
  def update_event_ui
    @page = Page.find(params[:id])
    @page.all_day_event = params[:all_day_event]
    @page.no_end_time = params[:no_end_time]
    render :partial => "event_dates_dynamic", :object => @page
  end
end