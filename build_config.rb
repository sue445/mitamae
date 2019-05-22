def gem_config(conf)
  #conf.gembox 'default'

  # be sure to include this gem (the cli app)
  conf.gem File.expand_path(File.dirname(__FILE__))

  conf.gem mgem: 'mruby-file-stat',      checksum_hash: '2d3ea9b5d59d2b41133228a71c110b75cb30a31e'
  conf.gem mgem: 'mruby-hashie',         checksum_hash: 'c69255a94debcd641f2087b569f5625509bde698'
  conf.gem mgem: 'mruby-io',             checksum_hash: '6836f424c5ff95d0114a426010b22254804bc9a3'
  conf.gem mgem: 'mruby-open3',          checksum_hash: 'b7480b6300a81d0e5fac469a36a383518e3dfc78'
  conf.gem mgem: 'mruby-shellwords',     checksum_hash: '2a284d99b2121615e43d6accdb0e4cde1868a0d8'
  conf.gem mgem: 'mruby-specinfra',      checksum_hash: 'efb18feeee0cb8d0d49c7a9eadbc0fc074c2be1c'
  conf.gem mgem: 'mruby-socket',         checksum_hash: 'a8b6d6ee4c6ccea81a805cc9204b36c3792123c9'
  conf.gem github: 'k0kubun/mruby-erb',  checksum_hash: '978257e478633542c440c9248e8cdf33c5ad2074'
  conf.gem github: 'eagletmt/mruby-etc', checksum_hash: 'v0.1.0'
end

def debug_config(conf)
  conf.instance_eval do
    # In `enable_debug`, use this for release build too.
    # Allow showing backtrace and prevent "fptr_finalize failed" error in mruby-io.
    @mrbc.compile_options += ' -g'
  end
end

build_targets = ENV.fetch('BUILD_TARGET', '').split(',')
if build_targets == ['all']
  build_targets = %w[
    linux-x86_64
    linux-i686
    linux-armhf
    darwin-x86_64
    darwin-i386
    windows-x86_64
    windows-i686
  ]
end

MRuby::Build.new do |conf|
  toolchain :gcc

  #conf.enable_bintest
  #conf.enable_debug
  #conf.enable_test

  debug_config(conf)
  gem_config(conf)
end

if build_targets.include?('linux-x86_64')
  MRuby::Build.new('x86_64-pc-linux-gnu') do |conf|
    toolchain :gcc

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('linux-i686')
  MRuby::CrossBuild.new('i686-pc-linux-gnu') do |conf|
    toolchain :gcc

    [conf.cc, conf.cxx, conf.linker].each do |cc|
      cc.flags << "-m32"
    end

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('linux-armhf')
  MRuby::CrossBuild.new('arm-linux-gnueabihf') do |conf|
    toolchain :gcc

    # See also: tools/mruby-cli/Dockerfile
    conf.cc.command       = 'arm-linux-gnueabihf-gcc'
    conf.cxx.command      = 'arm-linux-gnueabihf-g++'
    conf.linker.command   = 'arm-linux-gnueabihf-g++'
    conf.archiver.command = 'arm-linux-gnueabihf-ar'

    # For hone/mruby-yaml configure
    conf.build_target = 'x86_64-pc-linux-gnu'
    conf.host_target  = 'arm-linux-gnueabihf'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('darwin-x86_64')
  MRuby::CrossBuild.new('x86_64-apple-darwin14') do |conf|
    toolchain :clang

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'x86_64-apple-darwin14-clang'
    end
    conf.cxx.command      = 'x86_64-apple-darwin14-clang++'
    conf.archiver.command = 'x86_64-apple-darwin14-ar'

    conf.build_target     = 'x86_64-pc-linux-gnu'
    conf.host_target      = 'x86_64-apple-darwin14'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('darwin-i386')
  MRuby::CrossBuild.new('i386-apple-darwin14') do |conf|
    toolchain :clang

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'i386-apple-darwin14-clang'
    end
    conf.cxx.command      = 'i386-apple-darwin14-clang++'
    conf.archiver.command = 'i386-apple-darwin14-ar'

    conf.build_target     = 'i386-pc-linux-gnu'
    conf.host_target      = 'i386-apple-darwin14'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('windows-x86_64')
  MRuby::CrossBuild.new('x86_64-w64-mingw32') do |conf|
    toolchain :gcc

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'x86_64-w64-mingw32-gcc'
    end
    conf.cxx.command      = 'x86_64-w64-mingw32-g++'
    conf.archiver.command = 'x86_64-w64-mingw32-gcc-ar'

    conf.exts do |exts|
      exts.object = '.obj'
      exts.executable = '.exe'
      exts.library = '.lib'
    end

    conf.build_target     = 'x86_64-pc-linux-gnu'
    conf.host_target      = 'x86_64-w64-mingw32'

    debug_config(conf)
    gem_config(conf)
  end
end

if build_targets.include?('windows-i686')
  MRuby::CrossBuild.new('i686-w64-mingw32') do |conf|
    toolchain :gcc

    [conf.cc, conf.linker].each do |cc|
      cc.command = 'i686-w64-mingw32-gcc'
    end
    conf.cxx.command      = 'i686-w64-mingw32-g++'
    conf.archiver.command = 'i686-w64-mingw32-gcc-ar'

    conf.exts do |exts|
      exts.object = '.obj'
      exts.executable = '.exe'
      exts.library = '.lib'
    end

    conf.build_target     = 'i686-pc-linux-gnu'
    conf.host_target      = 'i686-w64-mingw32'

    debug_config(conf)
    gem_config(conf)
  end
end
