class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-8.4.2/qpdf-8.4.2.tar.gz"
  sha256 "69a30a65ef9398e6dbf151f1f6a31321cbc0f49b6cc0689ce10ea958bfd13ec3"

  bottle do
    cellar :any
    sha256 "68eee5574158ae1e60921b2893c34def314c3436fff7cb732d067d4f78ea48c7" => :mojave
    sha256 "259842ce26b6a629da98100998b3c4d63051a52f92efadb8f81b89d8416ad317" => :high_sierra
    sha256 "d7222ca0588e24dd256317890529655f6d28edcb2edc81d879778032570a4c45" => :sierra
  end

  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
