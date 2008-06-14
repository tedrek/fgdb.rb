class Notifier < ActionMailer::Base
  def volunteer_milestone_report( volunteers )
    recipients Default['volunteer_reports_to']
    from Default['my_email_address']
    subject "Volunteer Milestone Report"
    body :volunteers => volunteers
  end
end
