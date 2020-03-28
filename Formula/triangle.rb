class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.0.4.tar.gz"
  sha256 "f9a143dd36e69fa4ff321ba04223d9517c5b4ad57b17b30da649da90dce897b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "132a796ede448b5f82b5c07ced752c52330cb562f0c6a38e632cf03fa746084e" => :mojave
    sha256 "cab32e0bb1b7679d9fd01ac10fd417ebbc2372c36f946d2a702365c783d6dcb7" => :high_sierra
    sha256 "56cbb9d5869a4de632e195ec7617e5747fbec961a152d375b5fa22fbac4d3e77" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    dir = buildpath/"src/github.com/esimov/triangle"

    dir.install buildpath.children

    cd dir/"cmd/triangle" do
      system "go", "install"
    end
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
