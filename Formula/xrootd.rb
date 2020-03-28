class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.8.3/xrootd-4.8.3.tar.gz"
  sha256 "9cd30a343758b8f50aea4916fa7bd37de3c37c5b670fe059ae77a8b2bbabf299"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "114e764f63d15b02ddd6091f7d28f126584f5abbe493b6684bdcb1d39bc91f1d" => :mojave
    sha256 "9d0c1ebbf9d77d4afcd96aa8e12562a9678297306a000f2e1ac6d5a4fc5c2ad4" => :high_sierra
    sha256 "6c27e086bfab2dfda91e34814d588fd294c18f0cede4240b69582abc693f0a99" => :sierra
    sha256 "70bdb9f69fcda66b1ea863d55360ac65657cc6bfafb3adafef07115bd7fe0cfa" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
