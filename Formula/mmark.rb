class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.nl/"
  url "https://github.com/mmarkdown/mmark/archive/v2.0.46.tar.gz"
  sha256 "fa64a7321ff8cc531a0caa36af2a72057c5bebd634b623407b9d6415e7184003"

  bottle do
    cellar :any_skip_relocation
    sha256 "64668c943a366014740e8fb017fc7e6735454c1ba8d0314f8f618725d8d8a531" => :mojave
    sha256 "a77f99cc9523aeef1d1c0b55dccd094e5afa81e32444339a00432ef2c0029fce" => :high_sierra
    sha256 "13b0d3608fb714ebcd8fa34f5534e687921b24af764fd3348e7a9fc5f03b8491" => :sierra
  end

  depends_on "go" => :build

  resource "test" do
    url "https://raw.githubusercontent.com/mmarkdown/mmark/v2.0.7/rfc/2100.md"
    sha256 "2d220e566f8b6d18cf584290296c45892fe1a010c38d96fb52a342e3d0deda30"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    (buildpath/"src/github.com/mmarkdown/mmark").install buildpath.children
    cd "src/github.com/mmarkdown/mmark" do
      system "go", "build", "-o", bin/"mmark"
      man1.install "mmark.1"
      prefix.install_metafiles
    end
  end

  test do
    resource("test").stage do
      system "#{bin}/mmark", "-2", "-ast", "2100.md"
    end
  end
end
