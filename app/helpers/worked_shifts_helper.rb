module WorkedShiftsHelper
  def url_for_log(worker, date, controller = nil)
    worker = worker.id if worker.class == Worker
    date = date.to_date if date.class == DateTime
    date = date.to_s if date.class == Date
    h = {:controller => "worked_shifts", :action => "edit", :worked_shift => {:worker_id => worker, :date_performed => date}}
    if controller
      return controller.url_for h
    else
      url_for h
    end
  end
end
