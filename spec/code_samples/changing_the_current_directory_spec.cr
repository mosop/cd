require "../spec_helper"

module CdCodeSamples::ChangingTheCurrentDirectory
  it name do
    Dir.tmp do |tmp|
      Dir.cd(tmp) do
        Cd.into("foo") do
          Dir.current.should eq File.real_path(File.join(tmp, "foo"))
        end
      end
    end
  end
end
