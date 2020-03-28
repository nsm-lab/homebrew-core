class Srt < Formula
  desc "Secure Reliable Transport"
  homepage "https://www.srtalliance.org/"
  url "https://github.com/Haivision/srt/archive/v1.3.2.tar.gz"
  sha256 "1b8bfb52313cd2c5455b461b18e3ca1e3d2433e7ea01a02c68a50ab5c53ed0af"
  head "https://github.com/Haivision/srt.git"

  bottle do
    cellar :any
    sha256 "05c095fe08f26b93c8352c5b50f3af1a5b4d5c6922ec630af4da5b773f57f670" => :mojave
    sha256 "3fa85c4a24c41a81ec33987349b8b7280455229bbcbaf0be473aa39c4e54ecf5" => :high_sierra
    sha256 "d4650ec19ea87a3d1fbbb36cf1f4eb0c30e34444237ab63103754a11ecd2a013" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    openssl = Formula["openssl"]
    system "cmake", ".", "-DWITH_OPENSSL_INCLUDEDIR=#{openssl.opt_include}",
                         "-DWITH_OPENSSL_LIBDIR=#{openssl.opt_lib}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/stransmit file:///dev/null file://con/ 2>&1"
    assert_match "Unsupported source type", shell_output(cmd, 1)
  end
end
