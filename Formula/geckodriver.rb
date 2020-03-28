class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  url "https://github.com/mozilla/geckodriver/archive/v0.24.0.tar.gz"
  sha256 "e6f86b3b6411f078c0a762f978c00ee99926463036a68be01d111bd91f25340e"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    sha256 "a298af36e97630af54412dfd6539ab167a4d79718ecd8b35293bd2a2f548b347" => :mojave
    sha256 "bebf98611d54ba2a2226988e35c3ac099da175bf940393d99adefd22ad804de2" => :high_sierra
    sha256 "2f258830aa0c09fe2e67e7ca55c6498426a42901586bc6cbac5c59ca22d34fcc" => :sierra
  end

  depends_on "rust" => :build

  def install
    dir = build.head? ? "testing/geckodriver" : "."
    cd(dir) { system "cargo", "install", "--root", prefix, "--path", "." }
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
