class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.15.0.tar.gz"
  sha256 "6cdb97871f2930530c97deb7cf5c8fa4be5a0b02c7cea6e7c7667672a39d6852"

  bottle do
    cellar :any
    sha256 "6c1782cd4a17e74f8f7b6258faa754ddcf9bf3a388cb862d6b5da8832668f9ef" => :mojave
    sha256 "45fcb6953de6f43026bc28f3d8798ced5e5a0bbd28c18240fc0e9bc66174fc1e" => :high_sierra
    sha256 "3d2c45de57a6c1e9fe867d67fa4509d2d42aae5fef8f5d5fc1ea34afff2ff22b" => :sierra
  end

  head do
    url "https://github.com/bagder/c-ares.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./buildconf" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-debug"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"
  end
end
