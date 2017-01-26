module Cd
  class DirEntry
    # Defines helper methods for manipulating the given subentry.
    #
    # See `Examples::CrystalDir`.
    macro any(name, type = ::Cd::AnyEntry, method = nil, create = false, mode = nil)
      {%
        name = name.id
        method = name.split(".").join("_").split("-").join("_") unless method
        method = method.id
      %}

      @{{method}} : {{type}}?
      # Returns the {{name.stringify}} entry.
      {% if create %}
      #
      # If the entry does not exists, the empty file is automatically created.
      {% end %}
      #
      # This method is automatically defined by the Cd library.
      def {{method}} : {{type}}
        @{{method}} ||= begin
          %entry = {{type}}.new(join({{name.stringify}}))
          {% if create %}
            %entry.touch mode: {{mode}}
          {% end %}
          %entry
        end
      end

      # Returns the {{name.stringify}} entry if exists.
      #
      # This method is automatically defined by the Cd library.
      def {{method}}? : {{type}}?
        %entry = {{method}}
        return %entry if %entry.exists?
      end
    end
  end
end
