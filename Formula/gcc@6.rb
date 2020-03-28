class GccAT6 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-6.5.0/gcc-6.5.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-6.5.0/gcc-6.5.0.tar.xz"
  sha256 "7ef1796ce497e89479183702635b14bb7a46b53249209a5e0f999bebf4740945"
  revision 2

  bottle do
    sha256 "50d8452d2d87511d2e6d91b0487064d57b07d38c1022dc19fe0a4ccea7f2209e" => :mojave
    sha256 "93dc5c5ca44e01b074941cb96216ad948223dca5d04d354b0bfa11c536ff8e45" => :high_sierra
    sha256 "7737834f564e43eb4eb652accead7405382946bf1113eb10139b4421d385717b" => :sierra
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # Patch for Xcode bug, taken from https://gcc.gnu.org/bugzilla/show_bug.cgi?id=89864#c43
  # This should be removed in the next release of GCC if fixed by apple; this is an xcode bug,
  # but this patch is a work around committed to GCC trunk
  if MacOS::Xcode.version >= "10.2"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/gcc%406/gcc6-xcode10.2.patch"
      sha256 "0f091e8b260bcfa36a537fad76823654be3ee8462512473e0b63ed83ead18085"
    end
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # C, C++, ObjC, Fortran compilers are always built
    languages = %w[c c++ objc obj-c++ fortran]

    version_suffix = version.to_s.slice(/\d/)

    # Even when suffixes are appended, the info pages conflict when
    # install-info is run so pretend we have an outdated makeinfo
    # to prevent their build.
    ENV["gcc_cv_prog_makeinfo_modern"] = "no"

    osmajor = `uname -r`.chomp

    args = [
      "--build=x86_64-apple-darwin#{osmajor}",
      "--prefix=#{prefix}",
      "--libdir=#{lib}/gcc/#{version_suffix}",
      "--enable-languages=#{languages.join(",")}",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc"].opt_prefix}",
      "--with-isl=#{Formula["isl"].opt_prefix}",
      "--with-system-zlib",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      # Use 'bootstrap-debug' build configuration to force stripping of object
      # files prior to comparison during bootstrap (broken by Xcode 6.3).
      "--with-build-config=bootstrap-debug",
      "--disable-werror",
      "--with-pkgversion=Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip,
      "--with-bugurl=https://github.com/Homebrew/homebrew-core/issues",
      "--disable-nls",
    ]

    # Xcode 10 dropped 32-bit support
    args << "--disable-multilib" if DevelopmentTools.clang_build_version >= 1000

    # Ensure correct install names when linking against libgcc_s;
    # see discussion in https://github.com/Homebrew/homebrew/pull/34303
    inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}"

    mkdir "build" do
      if !MacOS::CLT.installed?
        # For Xcode-only systems, we need to tell the sysroot path
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{MacOS.sdk_path}"
      elsif MacOS.version >= :mojave
        # System headers are no longer located in /usr/include
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
      end

      system "../configure", *args
      system "make", "bootstrap"
      system "make", "install"
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    info.rmtree
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/gcc-6", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system "#{bin}/g++-6", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", `./hello-cc`

    fixture = <<~EOS
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      print *, "done"
      end
    EOS
    (testpath/"in.f90").write(fixture)
    system "#{bin}/gfortran-6", "-o", "test", "in.f90"
    assert_equal "done", `./test`.strip
  end
end
