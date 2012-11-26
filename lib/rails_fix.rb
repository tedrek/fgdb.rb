module ActiveRecord
  module Associations
    module ClassMethods
      class JoinDependency
        class JoinAssociation
          def association_join_with_fix
            connection = reflection.active_record.connection
            join = case reflection.macro
                   when :has_and_belongs_to_many
                     " #{join_type} %s ON %s.%s = %s.%s " % [
                                                             table_alias_for(options[:join_table], aliased_join_table_name),
                                                             connection.quote_table_name(aliased_join_table_name),
                                                             options[:foreign_key] || reflection.active_record.to_s.foreign_key,
                                                             connection.quote_table_name(parent.aliased_table_name),
                                                             reflection.active_record.primary_key] +
                       " #{join_type} %s ON %s.%s = %s.%s " % [
                                                               table_name_and_alias,
                                                               connection.quote_table_name(aliased_table_name),
                                                               klass.primary_key,
                                                               connection.quote_table_name(aliased_join_table_name),
                                                               options[:association_foreign_key] || klass.to_s.foreign_key
                                                              ]
                   when :has_many, :has_one
                     case
                     when reflection.options[:through]
                       through_conditions = through_reflection.options[:conditions] ? "AND #{interpolate_sql(sanitize_sql(through_reflection.options[:conditions]))}" : ''

                       jt_foreign_key = jt_as_extra = jt_source_extra = jt_sti_extra = nil
                       first_key = second_key = as_extra = nil

                       if through_reflection.options[:as] # has_many :through against a polymorphic join
                         jt_foreign_key = through_reflection.options[:as].to_s + '_id'
                         jt_as_extra = " AND %s.%s = %s" % [
                                                            connection.quote_table_name(aliased_join_table_name),
                                                            connection.quote_column_name(through_reflection.options[:as].to_s + '_type'),
                                                            klass.quote_value(parent.active_record.base_class.name)
                                                           ]
                       else
                         jt_foreign_key = through_reflection.primary_key_name
                       end

                       case source_reflection.macro
                       when :has_many
                         if source_reflection.options[:as]
                           first_key   = "#{source_reflection.options[:as]}_id"
                           second_key  = options[:foreign_key] || primary_key
                           as_extra    = " AND %s.%s = %s" % [
                                                              connection.quote_table_name(aliased_table_name),
                                                              connection.quote_column_name("#{source_reflection.options[:as]}_type"),
                                                              klass.quote_value(source_reflection.active_record.base_class.name)
                                                             ]
                         else
                           first_key   = source_reflection.association_foreign_key # through_reflection.klass.base_class.to_s.foreign_key
                           second_key  = source_reflection.primary_key_name # options[:foreign_key] || primary_key
                         end

                         unless through_reflection.klass.descends_from_active_record?
                           jt_sti_extra = " AND %s.%s = %s" % [
                                                               connection.quote_table_name(aliased_join_table_name),
                                                               connection.quote_column_name(through_reflection.active_record.inheritance_column),
                                                               through_reflection.klass.quote_value(through_reflection.klass.sti_name)]
                         end
                       when :belongs_to
                         first_key = primary_key
                         if reflection.options[:source_type]
                           second_key = source_reflection.association_foreign_key
                           jt_source_extra = " AND %s.%s = %s" % [
                                                                  connection.quote_table_name(aliased_join_table_name),
                                                                  connection.quote_column_name(reflection.source_reflection.options[:foreign_type]),
                                                                  klass.quote_value(reflection.options[:source_type])
                                                                 ]
                         else
                           second_key = source_reflection.primary_key_name
                         end
                       end

                       " #{join_type} %s ON (%s.%s = %s.%s%s%s%s) " % [
                                                                       table_alias_for(through_reflection.klass.table_name, aliased_join_table_name),
                                                                       connection.quote_table_name(aliased_join_table_name),
                                                                       connection.quote_column_name(parent.primary_key),
                                                                       connection.quote_table_name(parent.aliased_table_name),
                                                                       connection.quote_column_name(jt_foreign_key),
                                                                       jt_as_extra, jt_source_extra, jt_sti_extra
                                                                      ] +
                         " #{join_type} %s ON (%s.%s = %s.%s%s) " % [
                                                                     table_name_and_alias,
                                                                     connection.quote_table_name(aliased_table_name),
                                                                     connection.quote_column_name(first_key),
                                                                     connection.quote_table_name(aliased_join_table_name),
                                                                     connection.quote_column_name(second_key),
                                                                     as_extra
                                                                    ]

                     when reflection.options[:as] && [:has_many, :has_one].include?(reflection.macro)
                       " #{join_type} %s ON %s.%s = %s.%s AND %s.%s = %s" % [
                                                                             table_name_and_alias,
                                                                             connection.quote_table_name(aliased_table_name),
                                                                             "#{reflection.options[:as]}_id",
                                                                             connection.quote_table_name(parent.aliased_table_name),
                                                                             parent.primary_key,
                                                                             connection.quote_table_name(aliased_table_name),
                                                                             "#{reflection.options[:as]}_type",
                                                                             klass.quote_value(parent.active_record.base_class.name)
                                                                            ]
                     else
                       foreign_key = options[:foreign_key] || reflection.active_record.name.foreign_key
                       " #{join_type} %s ON %s.%s = %s.%s " % [
                                                               table_name_and_alias,
                                                               aliased_table_name,
                                                               foreign_key,
                                                               parent.aliased_table_name,
                                                               reflection.options[:primary_key] || parent.primary_key
                                                              ]
                     end
                   when :belongs_to
                     " #{join_type} %s ON %s.%s = %s.%s " % [
                                                             table_name_and_alias,
                                                             connection.quote_table_name(aliased_table_name),
                                                             reflection.klass.primary_key,
                                                             connection.quote_table_name(parent.aliased_table_name),
                                                             options[:foreign_key] || reflection.primary_key_name
                                                            ]
                   else
                     ""
                   end || ''
            join << %(AND %s) % [
                                 klass.send(:type_condition, aliased_table_name)] unless klass.descends_from_active_record?

            [through_reflection, reflection].each do |ref|
              join << "AND #{interpolate_sql(sanitize_sql(ref.options[:conditions], aliased_table_name))} " if ref && ref.options[:conditions]
            end

            join
          end
          alias_method_chain :association_join, :fix
        end
      end
    end
  end
end

module ActiveRecord
  module Associations
    class HasManyThroughAssociation
      def construct_joins_with_fix(custom_joins = nil)
        polymorphic_join = nil
        if @reflection.source_reflection.macro == :belongs_to
          reflection_primary_key = @reflection.klass.primary_key
          source_primary_key     = @reflection.source_reflection.primary_key_name
          if @reflection.options[:source_type]
            polymorphic_join = "AND %s.%s = %s" % [
                                                   @reflection.through_reflection.quoted_table_name, "#{@reflection.source_reflection.options[:foreign_type]}",
                                                   @owner.class.quote_value(@reflection.options[:source_type])
                                                  ]
          end
        else
          reflection_primary_key = @reflection.source_reflection.primary_key_name
          source_primary_key     = @reflection.source_reflection.association_foreign_key
          if @reflection.source_reflection.options[:as]
            polymorphic_join = "AND %s.%s = %s" % [
                                                   @reflection.quoted_table_name, "#{@reflection.source_reflection.options[:as]}_type",
                                                   @owner.class.quote_value(@reflection.through_reflection.klass.name)
                                                  ]
          end
        end

        "INNER JOIN %s ON %s.%s = %s.%s %s #{@reflection.options[:joins]} #{custom_joins}" % [
                                                                                              @reflection.through_reflection.quoted_table_name,
                                                                                              @reflection.quoted_table_name, reflection_primary_key,
                                                                                              @reflection.through_reflection.quoted_table_name, source_primary_key,
                                                                                              polymorphic_join
                                                                                             ]
      end
      alias_method_chain :construct_joins, :fix
    end
  end
end

module ActiveRecord
  module Reflection
    class AssociationReflection
      def association_foreign_key_with_fix
        @association_foreign_key ||= @options[:primary_key] || class_name.foreign_key
      end
      alias_method_chain :association_foreign_key, :fix
    end
  end
end

### EFFECTIVE DIFFERENCE ###
# --- /usr/lib/ruby/1.8/active_record/associations.rb.original	2012-02-25 10:58:08.000000000 -0800
# +++ /usr/lib/ruby/1.8/active_record/associations.rb	2012-02-25 12:19:49.000000000 -0800
# @@ -2096,8 +2096,8 @@
#                              klass.quote_value(source_reflection.active_record.base_class.name)
#                            ]
#                          else
# -                          first_key   = through_reflection.klass.base_class.to_s.foreign_key
# -                          second_key  = options[:foreign_key] || primary_key
# +                          first_key   = source_reflection.association_foreign_key # through_reflection.klass.base_class.to_s.foreign_key
# +                          second_key  = source_reflection.primary_key_name # options[:foreign_key] || primary_key
#                          end
#  
#                          unless through_reflection.klass.descends_from_active_record?
# @@ -2122,9 +2122,9 @@
#  
#                        " #{join_type} %s ON (%s.%s = %s.%s%s%s%s) " % [
#                          table_alias_for(through_reflection.klass.table_name, aliased_join_table_name),
# -                        connection.quote_table_name(parent.aliased_table_name),
# -                        connection.quote_column_name(parent.primary_key),
#                          connection.quote_table_name(aliased_join_table_name),
# +                        connection.quote_column_name(parent.primary_key),
# +                        connection.quote_table_name(parent.aliased_table_name),
#                          connection.quote_column_name(jt_foreign_key),
#                          jt_as_extra, jt_source_extra, jt_sti_extra
#                        ] +
# --- /usr/lib/ruby/1.8/active_record/associations/has_many_through_association.rb.original	2012-02-25 10:33:53.000000000 -0800
# +++ /usr/lib/ruby/1.8/active_record/associations/has_many_through_association.rb	2012-02-25 12:19:56.000000000 -0800
# @@ -160,7 +160,7 @@
#              end
#            else
#              reflection_primary_key = @reflection.source_reflection.primary_key_name
# -            source_primary_key     = @reflection.through_reflection.klass.primary_key
# +            source_primary_key     = @reflection.source_reflection.association_foreign_key
#              if @reflection.source_reflection.options[:as]
#                polymorphic_join = "AND %s.%s = %s" % [
#                  @reflection.quoted_table_name, "#{@reflection.source_reflection.options[:as]}_type",
# --- /usr/lib/ruby/1.8/active_record/reflection.rb.original	2012-02-25 10:33:47.000000000 -0800
# +++ /usr/lib/ruby/1.8/active_record/reflection.rb	2012-02-25 12:20:04.000000000 -0800
# @@ -192,7 +192,7 @@
#        end
#  
#        def association_foreign_key
# -        @association_foreign_key ||= @options[:association_foreign_key] || class_name.foreign_key
# +        @association_foreign_key ||= @options[:primary_key] || class_name.foreign_key
#        end
#  
#        def counter_cache_column
