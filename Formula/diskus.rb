class Diskus < Formula
  desc "Minimal, fast alternative to 'du -sh'"
  homepage "https://github.com/sharkdp/diskus"
  url "https://github.com/sharkdp/diskus/archive/v0.5.0.tar.gz"
  sha256 "90d785f3f24899a6adcc497846f29112812a887c8042d0657d6b258d5a5352bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "7da040e966d43d407079300ab07637e3749e92ac38efed09100ffeed4a5b786e" => :mojave
    sha256 "6ec0860e31ea78b947c60526ae4c4e9c6a13c215b6df9634cd021089d9505a7f" => :high_sierra
    sha256 "5409acf1a081c808632f9380b4060734709ea870f6d72dc65685eb706ef42797" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.txt").write("Hello World")
    output = shell_output("#{bin}/diskus #{testpath}/test.txt")
    assert_match /(\d+) B \(\1 bytes\)/, output
  end
end
