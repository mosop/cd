require "./lib"

module Cd
  # See `DirEntry.cd`.
  def self.into(*args, &block)
    DirEntry.cd(*args) do |dir|
      yield dir
    end
  end

  # See `DirEntry.tmp`.
  def self.tmp(base = "/tmp", &block)
    DirEntry.tmp(base) do |dir|
      yield dir
    end
  end

  # :nodoc:
  def self.join(*args)
    File.expand_path(File.join(*args), Dir.current)
  end

  # :nodoc:
  def self.mkdtemp(base)
    Dir.mkdir_p base
    p = "#{base}/XXXXXX".bytes + [0_u8]
    raise "mkdtemp() error." if C::Lib.mkdtemp(p) == 0
    String.new(p.to_unsafe)
  end
end
