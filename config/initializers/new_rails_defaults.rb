# These settings change the behavior of Rails 2 apps and will be defaults
# for Rails 3. You can remove this initializer when Rails 3 is released.

# No, it can't
# See note at the bottom
# The rest can be gotten rid of though
#    -- Ryan52

# Include Active Record class name as root for JSON serialized output.
ActiveRecord::Base.include_root_in_json = true

# Store the full class name (including module namespace) in STI type column.
ActiveRecord::Base.store_full_sti_class = true

# Use ISO 8601 format for JSON serialized times and dates.
ActiveSupport.use_standard_json_time_format = true

# Don't escape HTML entities in JSON, leave that for the #json_escape helper.
# if you're including raw json in an HTML page.
#ActiveSupport.escape_html_entities_in_json = false

# The previous option completely destroys our application.
# set it to true here, so that once rails 3 is released it will still work
#    -- Ryan52
ActiveSupport.escape_html_entities_in_json = true

