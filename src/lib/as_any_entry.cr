module Cd
  # Manupulates a file or directory path.
  module AsAnyEntry
    # Reads this entry as a file.
    def read
      File.read(path)
    end

    # Writes text to this entry as a file.
    def write(text, mode : Int? = nil)
      dir.create
      File.write path, text
      chmod(mode) if mode
    end

    # Appends text to this entry as a file.
    def append(text)
      File.open(path, "a") do |f|
        f << text
      end
    end

    # Changes this entry's mode.
    def chmod(mode : Int)
      File.chmod path, mode
    end

    # Creates an empty file if this entry does not exists.
    def touch(mode : Int? = nil)
      write "", mode: mode unless exists?
    end

    # Tests if this entry exists.
    def exists?
      File.exists?(path)
    end

    # Tests if this entry is a symlink.
    def symlink?
      File.symlink?(path)
    end

    # Tests if this entry is a file.
    def file?(*args)
      File.file?(path)
    end

    # Tests if this entry is a directory.
    def directory?(*args)
      File.directory?(path)
    end

    # Returns this entry's real path.
    def real_path
      File.real_path(path)
    end

    # Joins this entry's path and given path components.
    def join(*args)
      File.expand_path(File.join(*args), path)
    end

    # Writes this entry's path to the IO.
    def to_s(io : IO)
      io << path
    end

    # Copies this entry as a file to the *dst* path.
    def cp(dst : String)
      FileUtils.cp path, dst
      self
    end

    # Copies this entry as a file to the *dst* path.
    def cp(dst : AsAnyEntry)
      cp dst.path
    end

    # Returns a directory path that contains this entry.
    def dirname
      File.dirname(path)
    end

    # Returns this entry's base name.
    def basename(suffix : String?)
      File.basename(path, suffix)
    end

    # Returns a directory that contains this entry.
    def dir
      DirEntry.new(dirname)
    end

    # Tests if this entry is executable.
    def executable?(*args)
      File.executable?(path)
    end
  end
end
