require 'test_helper'

describe 'Lmfs' do
  before do
    Lmfs.reset
    Lmfs.configure do |config|
    end
  end

  after do
    Lmfs.reset
  end

  describe 'Gem' do
    it 'should have a version number' do
      refute_nil ::Lmfs::VERSION
    end
  end

  describe '#configure (default)' do
    it 'should equal default values' do
      assert_equal 'lmfs', Lmfs.configuration.pstoreName
    end
  end

  describe '#configure' do
    before do
      Lmfs.configure do |config|
        config.dataDir           = 'testDirectory'
        config.autoCreateDataDir = true
        config.pstoreName        = 'testFilename'
      end
    end

    it 'should equal config variables as set' do
      assert_equal 'testDirectory', Lmfs.configuration.dataDir
      assert_equal true,            Lmfs.configuration.autoCreateDataDir
      assert_equal 'testFilename',  Lmfs.configuration.pstoreName
    end

    after do
      FileUtils.rm_rf(Lmfs.configuration.dataDir)
    end
  end

  describe '#write' do
    before do
      Lmfs.configure do |config|
        config.autoCreateDataDir = true
      end

      @myObj             = {}
      @myObj[:things]    = 12345
      @myObj[:stuff]     = 'abcdef'
    end

    it 'return serialized String' do
      savedObj = Lmfs.write(:myKey, @myObj)
      savedObj.must_be_kind_of String
    end

    it 'input equals output' do
      savedObj    = Lmfs.write(:myKey, @myObj)
      returnedObj = Lmfs.read(:myKey)

      returnedObj.must_equal @myObj
    end

    after do
      FileUtils.rm_rf(Lmfs.configuration.dataDir)
    end
  end

  describe '#read' do
    before :each do
      Lmfs.configure do |config|
        config.autoCreateDataDir = true
      end

      # Test hash with different types of values.
      @myObj          = {}
      @myObj[:fixnum] = 12345
      @myObj[:string] = 'abcdef'
      @myObj[:array]  = ['abcdef', 12345]
      @myObj[:hash]   = Hash[:hi, 'hello', :by, 'goodbye']

      savedObj = Lmfs.write(:myKey, @myObj)
    end

    it 'return serialized object' do
      returnedObj = Lmfs.read(:myKey)
      returnedObj.must_be_kind_of Hash
    end

    after do
      FileUtils.rm_rf(Lmfs.configuration.dataDir)
    end
  end

  describe '#keys' do
    before :each do
      Lmfs.configure do |config|
        config.autoCreateDataDir = true
      end

      # Test hash with different types of values.
      @myObj1          = {}
      @myObj1[:fixnum] = 12345
      @myObj1[:string] = 'abcdef'
      @myObj1[:array]  = ['abcdef', 12345]
      @myObj1[:hash]   = Hash[:hi, 'hello', :by, 'goodbye']

      @myObj2          = {}
      @myObj2[:fixnum] = 12345
      @myObj2[:string] = 'abcdef'
      @myObj2[:array]  = ['abcdef', 12345]
      @myObj2[:hash]   = Hash[:hi, 'hello', :by, 'goodbye']

      # Saving 2 objects to different keys in Pstore.
      savedObj = Lmfs.write(:myKey1, @myObj1)
      savedObj = Lmfs.write(:myKey2, @myObj1)
    end

    it 'return PStore keys' do
      Lmfs.keys.must_equal [:myKey1, :myKey2]
    end

    after do
      FileUtils.rm_rf(Lmfs.configuration.dataDir)
    end
  end
end
