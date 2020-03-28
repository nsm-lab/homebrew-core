class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v1.3.0.tar.gz"
  sha256 "f694fe71cc6e3e6f583a9faf380825ea93b2635c4db8d1d3121b9ebcf736ac1c"
  head "https://github.com/ultravideo/kvazaar.git"

  bottle do
    cellar :any
    sha256 "bd3d6122ef8a4dcc079b1fb86a0fd5fac658ab39910a08e9aa07115d165fd5db" => :mojave
    sha256 "05a3d65ec220510434711ef1840a045661fba804cc9843d63c9d04f943ead15b" => :high_sierra
    sha256 "455b8355658cba100fafa8cd8f60c353a6b56da81fb0420171e04893f329d339" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # download small sample and try to encode it
    resource("videosample").stage do
      system bin/"kvazaar", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.hevc"
      assert_predicate Pathname.pwd/"lm20.hevc", :exist?
    end
  end
end
