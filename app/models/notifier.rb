class Notifier < ActionMailer::Base
  def text_report(mail_default_name, subj, data)
    recipients Default[mail_default_name]
    from Default['my_email_address']
    headers 'return-path' => Default['return_path'] if Default['return_path']
    subject subj
    body :text => data
  end

  def volunteer_milestone_report( volunteers )
    recipients Default['volunteer_reports_to']
    from Default['my_email_address']
    headers 'return-path' => Default['return_path'] if Default['return_path']
    subject "Volunteer Milestone Report"
    body :volunteers => volunteers
  end

  def staff_hours_summary_report(myworkers)
    recipients Default['scheduler_reports_to']
    from Default['my_email_address']
    headers 'return-path' => Default['return_path'] if Default['return_path']
    subject "Staff Hours Summary"
    body :myworkers => myworkers
  end

  def staff_hours_poke(myworker)
    recipients myworker.name + " <" + myworker.email + ">"
    from Default['my_email_address']
    reply_to Default['scheduler_reports_to']
    headers 'return-path' => Default['return_path'] if Default['return_path']
    subject "Please log your hours"
    body :myworker => myworker
  end
end
