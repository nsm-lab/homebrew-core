class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.18.tar.gz"
  sha256 "acc631d92ae030f64506c8309edc74bc0a7366150e4f881a2736b65f4972f4f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "9202028193e1a6b4d8ac93ddcf47cc70729c98d798cf4638039e08bf0bf9f79b" => :mojave
    sha256 "8cd879d9c29dcec9399c558fd39f76a47a06d66011b01ba02b14713744ec8c37" => :high_sierra
    sha256 "efcdc570e025422b7af02290cf99668c9d2595ffc736226e11dd104e9918f1ec" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    system "#{bin}/hebcal"
  end
end
