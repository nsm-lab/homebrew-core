class Webarchiver < Formula
  desc "Allows you to create Safari .webarchive files"
  homepage "https://github.com/newzealandpaul/webarchiver"
  url "https://github.com/newzealandpaul/webarchiver/archive/0.9.tar.gz"
  sha256 "8ea826038e923c72e75a4bbb1416910368140a675421f6aaa51fd0dea703f75c"
  head "https://github.com/newzealandpaul/webarchiver.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "92e1e8c98a3290a9653c827bee0ffa2cd153241fa69a27c1a7ed12bba9c497f6" => :mojave
    sha256 "9e5fc94fce8dce5c085a99e14ba6ded678bf381297716fb99790c18cde27067a" => :high_sierra
    sha256 "73c16d1980c3faef25f9a869c342890504eff94e29c36b2819236448b3433e2f" => :sierra
    sha256 "4b8f78ddd15e234ae0d5c1842a8ccd7e6a9c5b18bd8626ef7b1d8d88d23b6014" => :el_capitan
  end

  depends_on :xcode => ["6.0.1", :build]

  def install
    # Force 64 bit-only build, otherwise it fails on Mojave
    xcodebuild "SYMROOT=build", "-arch", "x86_64"

    bin.install "./build/Release/webarchiver"
  end

  test do
    system "#{bin}/webarchiver", "-url", "https://www.google.com", "-output", "foo.webarchive"
    assert_match /Apple binary property list/, shell_output("file foo.webarchive")
  end
end
