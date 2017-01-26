require "../spec_helper"

module CdCodeSamples::CreatingTemporaryDirectories
  it name do
    Cd.tmp do |tmp|
      tmp.cd("foo") do |foo|
        real_tmp = File.real_path("/tmp")
        Dir.current.should match /^#{real_tmp}\/.{6}\/foo$/
      end
    end
  end
end
