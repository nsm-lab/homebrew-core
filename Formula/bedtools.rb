class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.28.0.tar.gz"
  sha256 "0f3e5990b5713388531de699d43d195f1535a5772d832acfd47baa151a3a7e59"

  bottle do
    cellar :any
    sha256 "6c9819a00f8d56e97500c0eef57a3363fd18c4439ce18ac66c5b0d6638b1bd88" => :mojave
    sha256 "e1a7e656b89c764f9331a1924ef4b6113769051a260fb76c2a1eee8b4a39cf84" => :high_sierra
    sha256 "61677f8ce990c4b17ee07fdb9e4d78e2655253a1301f156ef0ad5698e77a37b3" => :sierra
  end

  depends_on "xz"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    prefix.install "RELEASE_HISTORY"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
