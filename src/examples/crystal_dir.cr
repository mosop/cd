require "../cd"
require "yaml"

module Cd
  # This module is only for documentation.
  module Examples
    # An example class  for `EntryDir.dir` and `EntryDir.any`.
    #
    # ```
    # class CrystalDir < Cd::EntryDir
    #   class SpecDir < Cd::EntryDir
    #     def files
    #       glob("**/*_spec.cr")
    #     end
    #   end
    #
    #   dir "spec", SpecDir
    #   any "shard.yml"
    #
    #   def shard
    #     YAML.parse(shard_yml.read)
    #   end
    #
    #   def version
    #     shard["version"].to_s
    #   end
    # end
    # ```
    class CrystalDir < Cd::DirEntry
      class SpecDir < Cd::DirEntry
        # Searches spec files.
        def files
          glob("**/*_spec.cr")
        end
      end

      dir "spec", SpecDir
      any "shard.yml"

      # Parses shard.yml and returns the result YAML::Any instance.
      def shard
        YAML.parse(shard_yml.read)
      end

      # Returns a version string given by shard.yml.
      def version
        shard["version"].to_s
      end
    end
  end
end
