require "./dir_entry/macros"

module Cd
  # Manipulates a directory path.
  class DirEntry
    include AsAnyEntry

    macro inherited
      class ::Cd::DirEntry
        # :nodoc:
        def new(klass : ::{{@type}}.class, path : String)
          ::{{@type}}.new(path)
        end

        # :nodoc:
        def [](klass : ::{{@type}}.class)
          new(::{{@type}}, @path)
        end
      end
    end

    # Returns this directory's path.
    getter path : String

    # :nodoc:
    def initialize(path : String)
      @path = File.expand_path(path, Dir.current)
    end

    # Creates a new instance in this instance context.
    #
    # Override this method if subclassified instances should be initialized in a special way.
    def new(path : String)
      self.class.new(path)
    end

    @tmpdirs = [] of String
    # :nodoc:
    def remove_tmpdirs
      while tmpdir = @tmpdirs.pop?
        FileUtils.rm_r tmpdir if Dir.exists?(tmpdir)
      end
    end

    # Changes the current directory.
    #
    # This method creates a new `DirEntry` instance with a path that joins the *args* path components.
    #
    # If the joined path is relative, the path is expanded under the current directory's path.
    #
    # The *block* is called with the new instance.
    #
    # The current directory is restored after the *block* returns.
    def self.cd(*args, &block)
      new(Cd.join(*args)).cd do |dir|
        yield dir
      end
    end

    # Changes the current directory.
    #
    # This method creates a new `DirEntry` instance with a path that joins this directory's path and the *args* path components.
    #
    # The *block* is called with the new instance.
    #
    # The current directory is restored after the *block* returns.
    def cd(*args, &block)
      d = new(join(*args))
      begin
        d.create
        Dir.cd(d.path) do
          yield d
        end
      ensure
        d.remove_tmpdirs
      end
    end

    # Creates a new `DirEntry` instance under this directory.
    def dir(*args)
      new(join(*args))
    end

    # Changes the current directory into a new temporary directory.
    #
    # This method creates a new `DirEntry` instance with the new temporary directory's path.
    #
    # The *block* is called with the new instance.
    #
    # The current directory is restored after the *block* returns.
    #
    # The temporary directory is removed after the *block* returns.
    #
    # ### Parameters
    #
    # * *base* : a directory path that the temporary directory is created in
    def self.tmp(base = "/tmp", &block)
      tmp = Cd.mkdtemp(base)
      begin
        cd(tmp) do |dir|
          yield dir
        end
      ensure
        FileUtils.rm_r tmp if Dir.exists?(tmp)
      end
    end

    # Changes the current directory into a new temporary directory.
    #
    # This method creates a temporary directory, using C mkdtemp, under this directory's path and a new `DirEntry` instance with a path that joins the temporary directory's path and the *args* path components.
    #
    # The *block* is called with tthe new instance.
    #
    # The temporary directory is removed after the *block* returns.
    def tmp(*args, &block)
      tmp = Cd.mkdtemp(@path)
      begin
        new(tmp).cd(*args) do |dir|
          yield dir
        end
      ensure
        FileUtils.rm_r tmp if Dir.exists?(tmp)
      end
    end

    # Creates and returns a new temporary directory.
    #
    # This method creates a new `DirEntry` instance with a path that joins the new temporary directory's path and the *args* path components.
    #
    # The temporary directory is created under this directory.
    #
    # If this instance is created by the `DirEntry#cd` method, the temporary directory is removed after the cd method returns.
    #
    # Otherwise, the temporary directory is never automatically removed.
    def tmp(*args)
      tmp = Cd.mkdtemp(@path)
      @tmpdirs << tmp
      new(tmp)
    end

    # Tests if this directory exists.
    def exists?
      Dir.exists?(@path)
    end

    # Searches and iterates file entries under this directory.
    #
    # ### Parameters
    #
    # * *patterns* : search patterns; each pattern is joined under this directory's path.
    def glob(*patterns, &block)
      Dir.glob(patterns.map{|i| join(i)}) do |f|
        yield AnyEntry.new(f)
      end
    end

    # Searches and returns file entries under this directory.
    #
    # ### Parameters
    #
    # * *patterns* : search patterns; each pattern is joined under this directory's path.
    def glob(*patterns) : Array(AnyEntry)
      entries = [] of AnyEntry
      glob(*patterns) do |f|
        entries << f
      end
      entries
    end

    # Copies all this directory's contents recursively to the *dst* path.
    def cp(dst : String)
      Dir.mkdir_p dst
      Dir.open(@path) do |dir|
        dir.each do |entry|
          if entry != "." && entry != ".."
            src = File.join(@path, entry)
            dest = File.join(dst, entry)
            FileUtils.cp_r src, dest
          end
        end
      end
    end

    # Copies all this directory's contents recursively to the *dst* path.
    def cp(dst : Cd)
      cp dst.path
    end

    # Creates and returns a new underlying `AnyEntry` instance.
    #
    # ### Parameters
    #
    # * *args* : path components under this directory
    def [](*args)
      AnyEntry.new(join(*args))
    end

    # Creates and returns a new underlying `AnyEntry` instance.
    #
    # Returns nil if the entry does not exist.
    #
    # ### Parameters
    #
    # * *args* : path components under this directory
    def []?(*args)
      e = self[*args]
      e if e.exists?
    end

    # Creates this directory.
    def create
      Dir.mkdir_p @path
      self
    end

    # Removes this directory.
    def remove(recursive = false)
      begin
        if recursive
          FileUtils.rm_rf @path
        else
          Dir.rmdir @path
        end
      rescue ex : Errno
        raise ex unless ex.errno == Errno::ENOENT
      end
    end

    # Iterates underlying entries.
    def each
      Dir.open(@path) do |d|
        d.each do |entry|
          yield AnyEntry.new(entry)
        end
      end
    end

    # :nodoc:
    def [](klass : DirEntry.class)
      self
    end
  end
end
