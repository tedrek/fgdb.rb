class LoadLshwOutput < ActiveRecord::Migration
  def self.up
    for report in Report.find(:all)
      file = "/var/www/fgss/lshw_xml/#{report.system_id.to_s}-#{report.role_id.to_s}-#{report.created_at.to_time.strftime("%Y-%m-%d-%H%M")}.xml" 
      if File.exist?(file)
        fd = File.open(file, 'r')
        report.lshw_output = fd.read
        fd.close
      else
      end
    end
  end

  def self.down
    raise "I DONT CARE"
  end
end
