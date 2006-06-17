def write_yaml_fixtures_to_file(sql, fixture_name)
  i = "000"
  File.open("#{RAILS_ROOT}/test/fixtures/#{fixture_name}.yml", 'w' ) do |file|
    data = ActiveRecord::Base.connection.select_all(sql)
    file.write data.inject({}) { |hash, record|
      hash["#{fixture_name}_#{i.succ!}"] = record
      hash
    }.to_yaml
  end
end

def import_model_fixture(model)
  filename = File.join(RAILS_ROOT,'test','fixtures',model.tableize + '.yml')
  success = Hash.new
  records = YAML::load( File.open(filename))
    @model = Class.const_get(model)
    @model.transaction do
      records.each do |r|
        row = r[1]
        @new_model = @model.new

        row.each_pair do |column, value|
          if column.to_sym
            @new_model.send(column + '=', value)
          else
            p "Column not found" + column.to_s
          end
        end


        begin
          if @new_model.save
            success[model.to_sym] = (success[model.to_sym] ? success[model.to_sym] + 1 : 1)
          end
        rescue
          p "#{@new_model.class.to_s} failed to import: " + r.inspect
          p @new_model.errors.inspect
        end
      end

     p "Total of #{success[model.to_sym]} #{@new_model.class.to_s} records imported successfully"
    end
end
