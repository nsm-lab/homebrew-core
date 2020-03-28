class Dcal < Formula
  desc "dcal(1) is to cal(1) what ddate(1) is to date(1)"
  homepage "https://alexeyt.freeshell.org/"
  url "https://alexeyt.freeshell.org/code/dcal.c"
  version "0.1.0"
  sha256 "d637fd27fc8d2a3c567b215fc05ee0fd9d88ba9fc5ddd5f0b07af3b8889dcba7"

  bottle do
    cellar :any_skip_relocation
    sha256 "95160b46c7fe651d0a808cba358c75b0346145e0ac9240dc1c91cb634e6f74f8" => :mojave
    sha256 "74f5e51d4dca180bf93dc6d6cd1a147245db0b03a49992b4e0850e0af991020e" => :high_sierra
    sha256 "e36329914f9b602d565480fbe28e4da3e581fc2d0623465666cb430590cc2519" => :sierra
    sha256 "4135558d3a30c78364170daf22dc36f3c22a14b2574754edc27d2483e711b948" => :el_capitan
    sha256 "f91b680d549342c293d0decae1fcd17d872951cedc20c329dcdd13a7478ed5fa" => :yosemite
    sha256 "b5a277ca3a307bb47b137a76e2c8ee0fc1420b09819f0055b1010ef4ce5bc7ba" => :mavericks
  end

  def install
    system ENV.cxx, "dcal.c", "-o", "dcal"
    bin.install "dcal"
  end

  test do
    system "#{bin}/dcal", "-3"
  end
end
