class Mailutils < Formula
  desc "Swiss Army knife of email handling"
  homepage "https://mailutils.org/"
  url "https://ftp.gnu.org/gnu/mailutils/mailutils-3.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/mailutils/mailutils-3.6.tar.gz"
  sha256 "a0dc30361195594f0bf08a2a2b4906222a36e3ec8936056abe808184ec513ef1"

  bottle do
    sha256 "d1e191fc899b56957fe5b81ead95466cb8332025226ca8c98e23171f45eb6cb0" => :mojave
    sha256 "e5971d7a4667cf9780fa723e92519524c3c60a2210db74ca57b91b8d94486978" => :high_sierra
    sha256 "79b96a7b7d055a1ff58735fcba664e35b5ca38d50d1ddb78685c8d1d002a8278" => :sierra
  end

  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "libtool"
  depends_on "readline"

  def install
    system "./configure", "--disable-mh",
                          "--prefix=#{prefix}",
                          "--without-guile",
                          "--without-tokyocabinet"
    system "make", "PYTHON_LIBS=-undefined dynamic_lookup", "install"
  end

  test do
    system "#{bin}/movemail", "--version"
  end
end
