class Libslax < Formula
  desc "Implementation of the SLAX language (an XSLT alternative)"
  homepage "http://www.libslax.org/"
  url "https://github.com/Juniper/libslax/releases/download/0.22.0/libslax-0.22.0.tar.gz"
  sha256 "a32fb437a160666d88d9a9ae04ee6a880ea75f1f0e1e9a5a01ce1c8fbded6dfe"

  bottle do
    sha256 "0d3ba0fdd3bde7b42ca4246cffe14e34064a75a9eb719e6a5b986101e05aa670" => :mojave
    sha256 "119f8062107d0621d36b62a87a7b2af4e7aff1b5b18bec2ddba32d1570eb0d4c" => :high_sierra
    sha256 "7b8f9a2b5da09d32b9d0f45458a0059ebecddf7e40e49f667ad9c6c5f2a75d84" => :sierra
    sha256 "6c74666ce37951d72d6589914d203362195431324d89aeb7702c4d5574ebe17e" => :el_capitan
    sha256 "ac6582a698eae9f96d92d29b9e0ea1fb25b74c969e52cc1a97a1830ac6bb0544" => :yosemite
  end

  head do
    url "https://github.com/Juniper/libslax.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "openssl"

  conflicts_with "genometools", :because => "both install `bin/gt`"

  def install
    # configure remembers "-lcrypto" but not the link path.
    ENV.append "LDFLAGS", "-L#{Formula["openssl"].opt_lib}"

    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    system "sh", "./bin/setup.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-libedit"
    system "make", "install"
  end

  test do
    (testpath/"hello.slax").write <<~EOS
      version 1.0;

      match / {
          expr "Hello World!";
      }
    EOS
    system "#{bin}/slaxproc", "--slax-to-xslt", "hello.slax", "hello.xslt"
    assert_predicate testpath/"hello.xslt", :exist?
    assert_match "<xsl:text>Hello World!</xsl:text>", File.read("hello.xslt")
  end
end
