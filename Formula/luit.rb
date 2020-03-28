class Luit < Formula
  desc "Filter run between arbitrary application and UTF-8 terminal emulator"
  homepage "https://invisible-island.net/luit/"
  url "https://invisible-mirror.net/archives/luit/luit-20180628.tgz"
  sha256 "7b84f63072589e9b03bb3e99e01ef344bb37793b76ad1cbb7b11f05000d64844"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fd907214b6c2fc1bda914531c8c0971c34c63aaa3478ca3f0c21ddbeca1bc0f7" => :mojave
    sha256 "8c1e5b87146d2ea2682b473193942bc92bcd52422d391aa74fb585859da05091" => :high_sierra
    sha256 "a71855f672f1416741873a9ff816f8d15980bb0002429937cb85fd6a21b0fd4c" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-x"
    system "make", "install"
  end

  test do
    require "pty"
    (testpath/"input").write("#end {bye}\n")
    PTY.spawn(bin/"luit", "-encoding", "GBK", "echo", "foobar") do |r, _w, _pid|
      assert_match "foobar", r.read
    end
  end
end
