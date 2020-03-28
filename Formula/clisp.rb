class Clisp < Formula
  desc "GNU CLISP, a Common Lisp implementation"
  homepage "https://clisp.sourceforge.io/"
  url "https://ftp.gnu.org/gnu/clisp/release/2.49/clisp-2.49.tar.bz2"
  mirror "https://ftpmirror.gnu.org/clisp/release/2.49/clisp-2.49.tar.bz2"
  sha256 "8132ff353afaa70e6b19367a25ae3d5a43627279c25647c220641fed00f8e890"
  revision 2

  bottle do
    cellar :any
    sha256 "d71cf96b9d303ec2de1cb091043a0ad1befa590bbe3ee027f7f94c03daf9f6a1" => :mojave
    sha256 "5bf6cb7c640be9841f8a433f2bdbbd872aaf01352355d8765266d19a699e23c1" => :high_sierra
    sha256 "a34dc97249cc2e5001dff9561137c8a4ebc010e6da3be23735d711566e4d7312" => :sierra
  end

  depends_on "libsigsegv"
  depends_on "readline"

  patch :DATA

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e2cc7c1/clisp/patch-src_lispbibl_d.diff"
    sha256 "fd4e8a0327e04c224fb14ad6094741034d14cb45da5b56a2f3e7c930f84fd9a0"
  end

  def install
    ENV.deparallelize # This build isn't parallel safe.
    ENV.O0 # Any optimization breaks the build

    # Clisp requires to select word size explicitly this way,
    # set it in CFLAGS won't work.
    ENV["CC"] = "#{ENV.cc} -m64"

    # Work around "configure: error: unrecognized option: `--elispdir"
    # Upstream issue 16 Aug 2016 https://sourceforge.net/p/clisp/bugs/680/
    inreplace "src/makemake.in", "${datarootdir}/emacs/site-lisp", elisp

    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=yes"

    cd "src" do
      # Multiple -O options will be in the generated Makefile,
      # make Homebrew's the last such option so it's effective.
      inreplace "Makefile" do |s|
        s.change_make_var! "CFLAGS", "#{s.get_make_var("CFLAGS")} #{ENV["CFLAGS"]}"
      end

      # The ulimit must be set, otherwise `make` will fail and tell you to do so
      system "ulimit -s 16384 && make"

      system "make", "check"

      system "make", "install"
    end
  end

  test do
    system "#{bin}/clisp", "--version"
  end
end

__END__
diff --git a/src/stream.d b/src/stream.d
index 5345ed6..cf14e29 100644
--- a/src/stream.d
+++ b/src/stream.d
@@ -3994,7 +3994,7 @@ global object iconv_range (object encoding, uintL start, uintL end, uintL maxint
 nonreturning_function(extern, error_unencodable, (object encoding, chart ch));

 /* Avoid annoying warning caused by a wrongly standardized iconv() prototype. */
-#ifdef GNU_LIBICONV
+#if defined(GNU_LIBICONV) && !defined(__APPLE_CC__)
   #undef iconv
   #define iconv(cd,inbuf,inbytesleft,outbuf,outbytesleft) \
     libiconv(cd,(ICONV_CONST char **)(inbuf),inbytesleft,outbuf,outbytesleft)
