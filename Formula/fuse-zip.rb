class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.6.0.tar.gz"
  sha256 "21985c78ab9787033cff7afe4d9a29252383fd28ce83eb0d9cc2b963a1c5d656"
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "2323a2a375f62f388cd23c117c69d8d5583f004f9b12bcb41b5951c28f06643b" => :mojave
    sha256 "9f3f6df480954b829b58f755c8bae180923c8118a94e6b9a28650d7b2c31af69" => :high_sierra
    sha256 "f6edb889c97544c4f145f1e682e97fb4dace8b97baa60a21df6708c7f1c6ca12" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"
  depends_on :osxfuse

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
