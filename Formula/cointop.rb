class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.3.4.tar.gz"
  sha256 "8024736c908c1253ab4d2cb30df0f1dc977ccc4e51abb4614b43131d3b7405b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "c86c477f34dda055020d6732e38bbcbb475a8cecf8b19691631adbf5d84a5a26" => :mojave
    sha256 "50f386cf61ac89b31b0f156841d6891bcf7f26ea6a740b96a01e043c01c36ac2" => :high_sierra
    sha256 "78a64204c0b7524b2a38879b40ee280e818e32973ebc82469cba2bea8882763a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/miguelmota/cointop"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "test"
  end
end
