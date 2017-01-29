require "../spec_helper"

module CdInternalSpecs::CreateDirectoryOnWritingFile
  it name do
    Dir.tmp do |tmp|
      entry = Cd::DirEntry.new(tmp)["dir", "file"]
      entry.write("test")
      entry.read.should eq "test"
    end
  end
end
