class Lv2 < Formula
  desc "Portable plugin standard for audio systems"
  homepage "http://lv2plug.in"
  url "http://lv2plug.in/spec/lv2-1.16.0.tar.bz2"
  sha256 "dec3727d7bd34a413a344a820678848e7f657b5c6019a0571c61df76d7bdf1de"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c5ae73974d83d50004207ad39161c5083d4246213c0140bded36d267a126a08" => :mojave
    sha256 "5c5ae73974d83d50004207ad39161c5083d4246213c0140bded36d267a126a08" => :high_sierra
    sha256 "b0f163fce66e26fefa0c1dc35db01662d5bacae2f96760e4e5b79b1ec383cfed" => :sierra
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--no-plugins", "--lv2dir=#{lib}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
