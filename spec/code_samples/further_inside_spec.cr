require "../spec_helper"

module CdCodeSamples::FurtherInside
  it name do
    Dir.tmp do |tmp|
      Dir.cd(tmp) do
        Cd.into("foo") do |foo|
          foo.cd("bar") do |bar|
            bar.cd("baz") do
              Dir.current.should eq File.real_path(File.join(tmp, "foo", "bar", "baz"))
            end
          end
        end
      end
    end
  end
end
