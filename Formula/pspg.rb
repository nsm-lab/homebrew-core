class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/1.6.5.tar.gz"
  sha256 "7a997af15b5a392b5112f826d88e808661986e1ef95bc344071dc8bd5e4f9204"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "94474c5562a6d6a77c3528609840991885b459b54016adc9df9594a81de32516" => :mojave
    sha256 "733c936b7e8d9647126e2add943591effe9b940c46dcd351fdcd0dc69f0817fb" => :high_sierra
    sha256 "a7feac970fc9e39c8eae91198c6086177f5368cc5790fdc0b356045f848212d3" => :sierra
  end

  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following line to your psql profile (e.g. ~/.psqlrc)
      \\setenv PAGER pspg
      \\pset border 2
      \\pset linestyle unicode
  EOS
  end

  test do
    assert_match "pspg-#{version.to_f}", shell_output("#{bin}/pspg --version")
  end
end
