# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# job_type :runner,  "cd :path && bin/rails runner -e :development ':task' :output"
every 1.day, at: ['6:00 am', '18:00 pm'] do
  runner "InventionOpportunity.autoset_inactive"
end

# Learn more: http://github.com/javan/whenever
