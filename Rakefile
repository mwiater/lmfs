require 'bundler/gem_tasks'
require 'rake/testtask'
require 'Lmfs'
require 'pp'
require 'fileutils'

# Run before any rake tasks
desc 'Rake: run before all tasks'
task :before do
  `find . -name ".DS_Store" -print0 | xargs -0 rm -rf`
  `find . -name "._*" -print0 | xargs -0 rm -rf`
  system 'clear'
end

desc 'List all rake tasks'
task :default do
  puts 'Rake Tasks:'
  system 'rake -T'
end
task default: :before

desc 'Run the Usage example from the README'
task :usageExample do
  # Test hash with different types of values.
  myObj          = {}
  myObj[:fixnum] = 12345
  myObj[:string] = 'abcdef'
  myObj[:array]  = ['abcdef', 12345]
  myObj[:hash]   = Hash[:hi, 'hello', :by, 'goodbye']

  # Print object to save
  puts '** Object to save **'
  pp myObj

  # Lmfs Configuration
  Lmfs.configure do |config|
    config.autoCreateDataDir = true
  end

  # Write serialized object (msgpack) to PStore. print serialized object
  puts "\n** Saved, serialized object (#write) **\n"
  pp serializedObject = Lmfs.write(:myKey, myObj)

  # Read serialized object (msgpack) from PStore, symbolize nested Hash keys in returned object.
  readObj = Lmfs.read(:myKey)

  # Compare input and output, ensure a match, print read object
  puts "\n** Object returned (#read) should be equal to initail object: [#{(readObj == myObj).to_s.upcase}] **"
  pp readObj

  # Remove directory
  pp Lmfs.configuration.dataDir
  FileUtils.rm_rf(Lmfs.configuration.dataDir)
end
task usageExample: :before

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end
task test: :before

namespace :yard do
  desc 'Generate Yard documentation to ./doc'
  require 'yard'
  YARD::Rake::YardocTask.new :generate do |task|
    task.options       = ['--db=./doc/.yardoc', '--output-dir=./doc'] # optional
    task.stats_options = ['--list-undoc'] # optional
  end
  task generate: :before
end

namespace :rubocop do
  desc 'autogen'
  task :autogen do
    system 'rubocop --auto-gen-config'
    system 'rubocop --config .rubocop_todo.yml'
  end
  task autogen: :before
end
