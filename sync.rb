#!/usr/bin/ruby

require 'yaml'
require 'set'

options = YAML.load(File.read('options.yaml'))

InotifyWait = 'inotifywait -r -m -e close_write -e move -e create -e delete'
Cleanup = Hash.new { |h,k| h[k] = [] }

Dir.chdir options[:localdir]

def synchronize(options, changed)
  if changed == :local
    unless`git status -s`.empty?
      `git add .`
      m = `git status -s`[0,200].gsub("\n", ', ')
      puts `git commit -m '#{m}'`
    end
    puts 'sync local -> remote'
    puts `git pull --no-edit`
    puts 'Start pushing changes to remote...'
    puts `git push`
  elsif changed == :remote
    puts 'sync remote -> local'
    puts 'Pull changes from remote...'
    puts `git pull --no-edit`
  end

  return $?.exitstatus == 0
end

def try_synchronize(options, changed)
  if !synchronize(options, changed)
    raise "Sync failed: #{changed}"
  end
end


def start_notifier name, queue, cmd
  Thread.start do
    begin
      start = ->() do
        puts "Start notifier: #{name}"
        p = IO.popen cmd
        Cleanup[name] << p.pid
        p
      end

      io = start.call

      while true
        line = io.gets
        if line.nil?
          io.close
          Cleanup[name].clear
          io = start.call
        elsif line.start_with? './.git/'
          next
        end
        queue.enq name
      end
    rescue => e
      puts "FATAL: #{name} thread failed"
      queue.enq :FAIL
      puts e.backtrace
    end
  end
end

def start_notifiers(options, queue)
  local = "#{InotifyWait} ."
  remote = %Q<ssh #{options[:remote]} '#{InotifyWait} "#{options[:remotedir]}/objects"'>

  [
    start_notifier(:local, queue, local),
    start_notifier(:remote, queue, remote),
  ]
end

queue = Queue.new

try_synchronize options, :remote
try_synchronize options, :local

notifiers = start_notifiers options, queue

begin
  while true
    changed = Set.new
    changed << queue.deq
    
    sleep 16
    changed << queue.deq until queue.empty?

    raise 'Notifier thread crashed!' if changed.include? :FAIL

    [:remote, :local].each do |notifier|
      try_synchronize options, notifier if changed.include? notifier
    end
  end
rescue
  puts 'ERROR'
  notifiers.each(&:kill)
  Cleanup.values.flatten.each do |pid|
    puts "Kill #{pid}"
    Process.kill 'INT', pid
  end
  raise
end
