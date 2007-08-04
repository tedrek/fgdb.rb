require 'rake/clean'

namespace :test do

  desc 'Measures test coverage'
  task :coverage do
    if rcov_exists?
      rm_f "coverage"
      rm_f "coverage.data"
      rcov = "rcov --rails --aggregate coverage.data --text-summary -Ilib"
      test_files = FileList.new("test/unit/*_test.rb", "test/functional/*_test.rb", "test/integration/*_test.rb")
      system("#{rcov} --html #{test_files}")
      puts "Report generated to ./coverage/index.html"
    else
      puts "rcov binary not found.  Have you install rcov or the rcov gem?"
    end
  end

end

# Iterates through the PATH and looks for 'rcov'.
#  NOTE: only tested on Linux.
def rcov_exists?
  ENV['PATH'].split(/:/).each do |path|
    if File.exists?(path + "/rcov")
      return true
    end
  end
  return false
end
