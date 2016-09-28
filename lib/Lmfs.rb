require 'Lmfs/version'
require 'pstore'
require 'msgpack'

# Lfms module
module Lmfs
  # Create configuration accessor
  class << self
    attr_accessor :configuration
  end

  # Create new configuration object
  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)

    # Post conficuration tasks
    if self.configuration.autoCreateDataDir
      unless File.directory?(self.configuration.dataDir)
        Dir.mkdir(self.configuration.dataDir, 0o777)
      end
    end
  end

  # Reset Lfms configuration to defaults
  def self.reset
    self.configuration = Configuration.new
  end

  # Configuration class
  class Configuration
    attr_accessor :autoCreateDataDir
    attr_accessor :symbolizeNames
    attr_accessor :dataDir
    attr_accessor :pstoreName

    # Initialize configuration
    def initialize
      # Default config values
      @autoCreateDataDir = false
      @symbolizeNames    = true
      @dataDir           = './lmfsData'
      @pstoreName        = 'lmfs'
    end
  end

  # Set up PStore based on Lfms configuration
  def self.storage
    require 'pstore'
    PStore.new("#{self.configuration.dataDir}/#{self.configuration.pstoreName}")
  end

  # Read the PStore data on the key supplied.
  #
  # @param key [String] the key of the PStore object to read.
  # @return [Hash] the object read from Pstore.
  def self.read(key)
    data = nil

    store = storage
    store.transaction do
      data = MessagePack.unpack(store[key.to_s.to_sym])
    end

    deepSymbolize = lambda do |h|
      Hash === h ? Hash[h.map { |k, v| [k.respond_to?(:to_sym) ? k.to_sym : k, deepSymbolize[v]] }] : h
    end

    self.configuration.symbolizeNames ? deepSymbolize[data] : data
  end

  # Read the PStore data on the key supplied.
  #
  # @param key [String] the key of the PStore object to write.
  # @param data [Hash] the data to write to the PStore file
  def self.write(key, data)
    store = storage
    store.transaction do
      store[key.to_s.to_sym] = data.to_msgpack
    end
  end

  # Fetch all of the PStore keys
  #
  # @return [Array] of the keys in the PStore
  def self.keys
    keys = nil

    store = storage
    store.transaction do
      keys = store.roots
    end

    keys
  end
end
