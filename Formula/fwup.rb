class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.3.1/fwup-1.3.1.tar.gz"
  sha256 "67afd3c21ea2e2dc806ea66ecb5def42d72fc194c74da40438c5a1edc4df3931"

  bottle do
    cellar :any
    sha256 "46f784f18ff96014fc8b259275495acb34161e0c703d430a9537cd52f60a0006" => :mojave
    sha256 "408355b57d37c6811d3d263c62294072dbffa479a1e884a3db882a79a9d9622b" => :high_sierra
    sha256 "09afa3869372eee0155d5523168b96f475de1175c2daa4b8522485583b041bcf" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
