class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/6.0.0.tar.gz"
  sha256 "264a7689561bb498f97f10231959bdd8f7c873671bac2ffb660de9a5863b1c76"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d1213f610f53f86dad1a2232559efb129932bac0e2b0201ca092049bc548582" => :mojave
    sha256 "2427e4319a73db71b2c8eaf7b2ef71ca4e7732054aef09d83e4215c854684388" => :high_sierra
    sha256 "2427e4319a73db71b2c8eaf7b2ef71ca4e7732054aef09d83e4215c854684388" => :sierra
  end

  depends_on "imagemagick"
  depends_on "screenresolution"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
