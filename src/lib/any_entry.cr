module Cd
  # Manipulates a file or directory path.
  class AnyEntry
    include AsAnyEntry

    getter path : String

    def initialize(@path : String)
    end
  end
end
