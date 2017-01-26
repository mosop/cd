# Cd

A Crystal library for walking through directories and manipulating file entries in its object-oriented way.

[![Build Status](https://travis-ci.org/mosop/cd.svg?branch=master)](https://travis-ci.org/mosop/cd)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cd:
    github: mosop/cd
```

<a name="code_samples"></a>

## Code Samples

### Changing the Current Directory

```crystal
Cd.into("/path/to/foo") do
  Dir.current # "/path/to/foo"
end
```

### Further Inside

```crystal
Cd.into("/path/to/foo") do |foo|
  foo.cd("bar") do |bar|
    bar.cd("baz") do
      Dir.current # "/path/to/foo/bar/baz"
    end
  end
end
```

### Searching Underlying Entries

```crystal
Cd.into("/path/to/foo") do
  foo.glob("src/**/*.cr") do |entry|
    puts entry
  end
end
```

Output Example:

```
/path/to/foo/src/foo/bar.cr
/path/to/foo/src/foo/version.cr
/path/to/foo/src/foo.cr
```

### Helpers

```crystal
Cd.into("/path/to/foo") do
  foo.symlink?
  foo.real_path
  foo.join("bar", "baz")
  foo.cp "/path/to/dst"
end
```

### Creating Temporary Directories

```crystal
Cd.tmp("/path/to/tmp") do |tmp|
  tmp.cd("foo") do
    Dir.current # "/path/to/tmp/fLC8nt/foo"
  end
end

Dir.exists?("/path/to/tmp/fLC8nt/foo") # false
```

### Make it Your Own

```crystal
class SpecDir < Cd::DirEntry
  def files
    glob("**/*_spec.cr")
  end
end

class CrystalDir < Cd::DirEntry
  dir "spec", SpecDir
  any "shard.yml"

  def specs
    spec.glob("*_spec.cr")
  end

  def shard
    YAML.parse(shard_yml.read)
  end

  def version
    shard["version"].as_s
  end
end

kemal = CrystalDir.new("/path/to/kemal")

puts "Listing kemal (v#{kemal.version}) specs."

kemal.spec.files.each do |f|
  puts f
end
```

Output example:

```
Listing kemal (v0.17.5) spec files.
/path/to/kemal/spec/all_spec.cr
/path/to/kemal/spec/common_exception_handler_spec.cr
/path/to/kemal/spec/common_log_handler_spec.cr
/path/to/kemal/spec/config_spec.cr
/path/to/kemal/spec/context_spec.cr
/path/to/kemal/spec/handler_spec.cr
/path/to/kemal/spec/helpers_spec.cr
/path/to/kemal/spec/init_handler_spec.cr
/path/to/kemal/spec/param_parser_spec.cr
/path/to/kemal/spec/route_handler_spec.cr
/path/to/kemal/spec/route_spec.cr
/path/to/kemal/spec/run_spec.cr
/path/to/kemal/spec/view_spec.cr
/path/to/kemal/spec/websocket_handler_spec.cr
```

## Usage

```crystal
require "cd"
```

and see:

* [Code Samples](#code_samples)
* [API Document](http://mosop.me/cd/Cd.html)
