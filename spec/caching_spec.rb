require 'fileutils'

describe 'the regu caching mechanism' do
  
  before :each do
    FileUtils.rm_rf '.regu'
    
    /asdf/.cached_regu
  end
  
  let(:cached_files) { Dir['.regu/*'] }
  let(:reg) { Marshal.load(File.read(cached_files[0])) }
  
  it 'should make a file' do    
    cached_files.size.should == 1
  end
  
  it 'should have right type' do
    (Regu::Table === reg).should be_true
  end
  
  it 'should accept same strings' do
    reg.accepts?('asdf').should be_true
  end
  
end