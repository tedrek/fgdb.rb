module ActiveRecord
  # This class is used to dump the database schema for some connection to some
  # output format (i.e., ActiveRecord::Schema).
  class SchemaDumper
    include SchemaProcs

    # TODO -Implement checks on SchemaDumper instance 
    # to ensure we do this only when using pg db.
    def postgres?
      adapter_name == 'PostgreSQL'
    end

    private
      def get_type(types)
        case types
          when Array
            types.collect {|type|
              get_type(type)
            }.join(", ")
          when String && /^\d+$/
            type = @connection.select_value("SELECT typname FROM pg_type WHERE oid = '#{types}'")
            return type = 'nil' if type == 'void'
            get_type(type)
          when String
            return %("#{types}") if types =~ /[\s\(]/
            MyInflector.symbolize(types)
        end
      end

      # TODO - Facilitate create_proc(name, [argname, argtype] and create_proc(name, [argmode, argname, argtype] ...
      def procedures(stream, conditions=nil)
        @connection.procedures(conditions).each { |proc_row|
          oid, name, namespace, owner, lang, is_agg, sec_def, is_strict, ret_set, volatile, nargs, ret_type, arg_types, arg_names, src, bin, acl = proc_row
          is_agg    = is_agg    == 't'
          is_strict = is_strict == 't'
          ret_set   = ret_set   == 't'
          arg_names ||= ''
          args      = get_type(arg_types.split(" "))#.zip(arg_names.split(" "))

          stream.print "  create_proc(#{MyInflector.symbolize(name)}, [#{args}], :return => #{get_type(ret_type)}"
          stream.print ", :resource => ['#{bin}', '#{src.gsub("'", "\\\\'")}']" unless (bin == '-' or bin.nil?)
          stream.print ", :set => true" if ret_set
          stream.print ", :strict => true" if is_strict
          stream.print ", :behavior => '#{behavior(volatile)}'" unless volatile == 'v'
          stream.print ", :lang => '#{lang}')"
          if (bin == '-' or bin.nil?)
            chomped_src = src.sub(/^\n+/, '').sub(/\n+$/, '')
            stream.print " {\n    <<-#{(name).underscore}_sql\n#{chomped_src}\n    #{(name).underscore}_sql\n  }"
          end
          stream.print "\n"
        }
      end

      def schemas(stream)
        schemas = @connection.schemas
        schemas.each {|schema|
          stream.puts schema.to_rdl
        }
        stream.puts unless schemas.empty?
      end

      def triggers(table_name, stream)
        triggers = @connection.triggers(table_name)
        triggers.each {|trigger|
          stream.puts trigger.to_rdl
        }
        stream.puts unless triggers.empty?
      end

      def types(stream)
        @connection.types.each {|type|
          stream.print "  create_type(#{MyInflector.symbolize(type.name)}, "
          stream.print "#{ type.columns.collect{|column, type| "[#{MyInflector.symbolize(column)}, #{get_type(type)}]"}.join(", ") }"
          stream.puts  ")"
        }
      end
  end
end
