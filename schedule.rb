# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :path, ENV.fetch('APP_HOME', Whenever.path)
set :job_template, "/bin/sh -l -c ':job'"

job_type :rake, 'cd :path && :bundle_command rake :task --silent :output'

every :sunday, at: '11pm', roles: :fetcher do
  rake 'fetch:stocks drive:upload'
end

every :day, at: 'midnight', roles: :timebutler do
  rake 'travel:ahead'
end

every :day, at: '1am', roles: :scraper do
  rake 'drive:download scrape:stocks drive:upload'
end

every '*/15 8-23 * * mon-fri', roles: :intra do
  rake 'scrape:intra drive:upload'
end

every :hour, roles: :sbridge do
  rake 'import:stocks'
end
