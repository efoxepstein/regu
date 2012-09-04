class Regexp
  def regu
    Regu[source]
  end
  
  def cached_regu(base_dir = '.regu')
    filename = '%s/%s.%s' % [base_dir.to_s, source.gsub(/[^a-zA-Z0-9]/,''), Digest::SHA1.hexdigest(source)]
    
    FileUtils.mkdir_p base_dir
    
    if File.exists? filename
      File.open(filename, 'rb') {|f| Marshal.load(f)}
    else
      Regu[source].tap do |r|
        File.open(filename, 'wb') {|f| Marshal.dump(r, f) }
      end
    end
  end
end
