class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
      :tag      => "R_0_7_3",
      :revision => "c8063b741a602c6b693084987228cac65e2fde5b"
  version "0.7.3"
  head "https://github.com/cern-it-sdc-id/davix.git"

  bottle do
    cellar :any
    sha256 "85564894b2b7eb8f1896a815e1b3b9fe0bdcd1598060ec3872ec1fa0806f96d7" => :mojave
    sha256 "702eb13a7e16c4f73904f064bedce4a9e13a95d72b5428e5684ad3f5bb9566e9" => :high_sierra
    sha256 "324217f79b199881b1ea5967702d5deae7d3181d65c2162862345619534e9954" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@2" => :build
  depends_on "openssl"

  def install
    ENV.libcxx

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://www.google.com"
  end
end
