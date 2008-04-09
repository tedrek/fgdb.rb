class LoadLshwOutput < ActiveRecord::Migration
  def self.up
    for report in Report.find(:all)
      file = "/var/www/fgss/lshw_xml/#{system_id.to_s}-#{role_id.to_s}-#{report.created_at.to_date.strftime("%Y-%m-%d-%H%M")}.xml" 
      if File.exist?(file)
        fd = File.open(file, 'r')
        report.lshw_output = fd.read
        fd.close
      else
        if report.lshw_output == nil || report.lshw_output == ""
          raise "report ##{report.id} = no file + no date in db = bad!"
        end
      end
    end
  end

  def self.down
    raise "I don't know and I don't care!"
  end
end
