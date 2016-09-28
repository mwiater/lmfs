# Lmfs

During application protoyping, I've found myself rewriting local storage methods over and over. Lmfs is an attempt at standardizing this code, making it reusable as a ruby gem. In this simplified state it is working properly and passing all spec tests.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lmfs', :git => 'git://github.com/mwiater/lmfs.git'
```

And then execute:

    $ bundle

## Usage

#### Configuration
With default options:
```
Lmfs.configure do |config|
end
```

With custom options:
```
Lmfs.configure do |config|
  config.autoCreateDataDir = true                   # Auto-create the Lmfs directory if it doesn't exist. Default: false
  config.symbolizeNames    = false                  # Symbolize names in the returned read object.        Default: true
  config.dataDir           = './lmfsDataDirectory'  # The directory to store the Lmfs data                Default: './lmfsData'
  config.pstoreName        = 'lmfsData'             # The name of the PStore file.                        Default: 'lmfs'
end
```

#### Usage
Read/Write:
```
# Test hash with different types of values.
myObj          = {}
myObj[:fixnum] = 12345
myObj[:string] = "abcdef"
myObj[:array]  = ["abcdef", 12345]
myObj[:hash]   = Hash[:hi, "hello", :by, "goodbye"]

# Print object to save
puts "** Object to save **"
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
```

## Rake Tasks
Simply run `rake` to generate the list of available tasks:

```
Rake Tasks:
rake before           # Rake: run before all tasks
rake build            # Build Lmfs-0.1.0.gem into the pkg directory
rake clean            # Remove any temporary products
rake clobber          # Remove any generated files
rake default          # List all rake tasks
rake install          # Build and install Lmfs-0.1.0.gem into system gems
rake install:local    # Build and install Lmfs-0.1.0.gem into system gems without network access
rake release[remote]  # Create tag v0.1.0 and build and push Lmfs-0.1.0.gem to Rubygems
rake test             # Run tests
rake usageExample     # Run the Usage example from the README
rake yard:generate    # Generate Yard documentation to ./doc
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lmfs.