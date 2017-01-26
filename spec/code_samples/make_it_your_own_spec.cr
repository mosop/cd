require "../spec_helper"

module CdCodeSamples::MakeItYourOwn
  class SpecDir < Cd::DirEntry
    def files
      glob("**/*_spec.cr")
    end
  end

  class CrystalDir < Cd::DirEntry
    dir "spec", SpecDir
    any "shard.yml"

    def shard
      YAML.parse(shard_yml.read)
    end

    def version
      shard["version"].as_s
    end
  end

  it name do
    dir = File.join(__DIR__, "make_it_your_own")
    Stdio.capture do |io|
      kemal = CrystalDir.new(dir)

      puts "Listing kemal (v#{kemal.version}) spec files."

      kemal.spec.files.each do |f|
        puts f.path
      end
      io.out.gets_to_end.chomp.should eq <<-EOS
      Listing kemal (v0.17.5) spec files.
      #{dir}/spec/all_spec.cr
      #{dir}/spec/common_exception_handler_spec.cr
      #{dir}/spec/common_log_handler_spec.cr
      #{dir}/spec/config_spec.cr
      #{dir}/spec/context_spec.cr
      #{dir}/spec/handler_spec.cr
      #{dir}/spec/helpers_spec.cr
      #{dir}/spec/init_handler_spec.cr
      #{dir}/spec/param_parser_spec.cr
      #{dir}/spec/route_handler_spec.cr
      #{dir}/spec/route_spec.cr
      #{dir}/spec/run_spec.cr
      #{dir}/spec/view_spec.cr
      #{dir}/spec/websocket_handler_spec.cr
      EOS
    end
  end
end
