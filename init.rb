#!/usr/bin/ruby

require 'yaml'

if ARGV.size != 3
  puts 'Usage: ./init.rb localdir remote remotedir'
  raise 'Need 3 args'
end

localdir, remote, remotedir = ARGV

options = {
  localdir: localdir,
  remote: remote,
  remotedir: remotedir
}

File.write 'options.yaml', YAML.dump(options)

puts `git clone 'ssh://#{remote}/~/#{remotedir}' '#{localdir}'`
Dir.chdir localdir

if Dir.entries('.').size == 3 # ., .., .git
  File.write('.gitignore', '')
  puts `git add . && git commit -m 'Initial commit' && git push`
end

puts ''

puts "please run: crontab -e"
puts "add rule: */2 * * * * nice -n 19 #{Dir.pwd}/sync.sh #{localdir}"
