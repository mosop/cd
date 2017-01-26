require "../spec_helper"

module CdCodeSamples::SearchingUnderlyingEntries
  it name do
    Cd.into(__DIR__, "searching_underlying_entries") do |foo|
      Stdio.capture do |io|
        foo.glob("src/**/*.cr") do |entry|
          puts entry
        end
        io.out.gets_to_end.chomp.should eq <<-EOS
        #{foo}/src/foo/bar.cr
        #{foo}/src/foo/version.cr
        #{foo}/src/foo.cr
        EOS
      end
    end
  end
end
