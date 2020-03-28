class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "https://sdcc.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.9.0/sdcc-src-3.9.0.tar.bz2"
  sha256 "94ecae73faf7f3feee307f89dfe3cef2d7866293c7909ea05b3b33c88d67c036"
  head "https://svn.code.sf.net/p/sdcc/code/trunk/sdcc"

  bottle do
    sha256 "a4cfec7484f490988b439426b05310c4ddcd155a16f6d95967b0265e62b82a6c" => :mojave
    sha256 "79f6440540864bb4fdbe3a30619c3dec35e5daa9ae012c979882e9e95c27d088" => :high_sierra
    sha256 "129e06c6cab2f160d8eb9da70030443d9ffb783bd346be52a05b1af4b95d22ba" => :sierra
  end

  depends_on "boost"
  depends_on "gputils"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
