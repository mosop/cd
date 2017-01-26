module Cd
  class DirEntry
    # Defines helper methods for manipulating the given subdirectory.
    #
    # See `Examples::CrystalDir`.
    macro dir(name, type = ::Cd::DirEntry, method = nil)
      {%
        name = name.id
        method = name.split(".").join("_").split("-").join("_") unless method
        method = method.id
      %}
      @{{method}} : {{type}}?
      # Gets the {{name.stringify}} directory.
      #
      # This method is automatically defined by the Cd library.
      def {{method}} : {{type}}
        @{{method}} ||= new(join({{name.stringify}}))[{{type}}]
      end

      # Changes the current directory into the {{name.stringify}} directory.
      #
      # This method is automatically defined by the Cd library.
      def {{method}}(&block : {{type}} ->)
        cd({{name.stringify}}) do |dir|
          yield dir[{{type}}]
        end
      end
    end
  end
end
