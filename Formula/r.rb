class R < Formula
  desc "Software environment for statistical computing"
  homepage "https://www.r-project.org/"
  url "https://cran.r-project.org/src/base/R-3/R-3.6.1.tar.gz"
  sha256 "5baa9ebd3e71acecdcc3da31d9042fb174d55a42829f8315f2457080978b1389"

  bottle do
    sha256 "1ed9fe16ae694fa3b35a7d979853447eb7b8aec1e804019a1bf4aafa299a6696" => :mojave
    sha256 "517c692e736501f2ad5bd43b994fac4575e92aa6b30c3bf1cfbf67ee98b6f039" => :high_sierra
    sha256 "0f4badf64b95ec418db65429258c9aa6a26dc75156a74bef28e5858d73d459d0" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "gettext"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "openblas"
  depends_on "pcre"
  depends_on "readline"
  depends_on "xz"

  # needed to preserve executable permissions on files without shebangs
  skip_clean "lib/R/bin"

  resource "gss" do
    url "https://cloud.r-project.org/src/contrib/gss_2.1-10.tar.gz", :using => :nounzip
    mirror "https://mirror.las.iastate.edu/CRAN/src/contrib/gss_2.1-10.tar.gz"
    sha256 "26c47ecae6a9b7854a1b531c09f869cf8b813462bd8093e3618e1091ace61ee2"
  end

  def install
    # Fix dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    if MacOS.version == "10.11" && MacOS::Xcode.installed? &&
       MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_have_decl_clock_gettime"] = "no"
    end

    args = [
      "--prefix=#{prefix}",
      "--enable-memory-profiling",
      "--without-cairo",
      "--without-x",
      "--with-aqua",
      "--with-lapack",
      "--enable-R-shlib",
      "SED=/usr/bin/sed", # don't remember Homebrew's sed shim
      "--disable-java",
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]

    # Help CRAN packages find gettext and readline
    ["gettext", "readline"].each do |f|
      ENV.append "CPPFLAGS", "-I#{Formula[f].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula[f].opt_lib}"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize do
      system "make", "install"
    end

    cd "src/nmath/standalone" do
      system "make"
      ENV.deparallelize do
        system "make", "install"
      end
    end

    r_home = lib/"R"

    # make Homebrew packages discoverable for R CMD INSTALL
    inreplace r_home/"etc/Makeconf" do |s|
      s.gsub!(/^CPPFLAGS =.*/, "\\0 -I#{HOMEBREW_PREFIX}/include")
      s.gsub!(/^LDFLAGS =.*/, "\\0 -L#{HOMEBREW_PREFIX}/lib")
      s.gsub!(/.LDFLAGS =.*/, "\\0 $(LDFLAGS)")
    end

    include.install_symlink Dir[r_home/"include/*"]
    lib.install_symlink Dir[r_home/"lib/*"]

    # avoid triggering mandatory rebuilds of r when gcc is upgraded
    inreplace lib/"R/etc/Makeconf", Formula["gcc"].prefix.realpath,
                                    Formula["gcc"].opt_prefix
  end

  def post_install
    short_version =
      `#{bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
    site_library = HOMEBREW_PREFIX/"lib/R/#{short_version}/site-library"
    site_library.mkpath
    ln_s site_library, lib/"R/site-library"
  end

  test do
    assert_equal "[1] 2", shell_output("#{bin}/Rscript -e 'print(1+1)'").chomp
    assert_equal ".dylib", shell_output("#{bin}/R CMD config DYLIB_EXT").chomp

    testpath.install resource("gss")
    system bin/"R", "CMD", "INSTALL", "--library=.", Dir["gss*"].first
    assert_predicate testpath/"gss/libs/gss.so", :exist?,
                     "Failed to install gss package"
  end
end
