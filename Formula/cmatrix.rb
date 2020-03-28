class Cmatrix < Formula
  desc "Console Matrix"
  homepage "https://www.asty.org/cmatrix/"
  url "https://www.asty.org/cmatrix/dist/cmatrix-1.2a.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cmatrix/cmatrix_1.2a.orig.tar.gz"
  sha256 "1fa6e6caea254b6fe70a492efddc1b40ad7ccb950a5adfd80df75b640577064c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ae9acaacb6023d2837e2cbf5f7b09acd65035771f61e3c75efc58a4cbcf7dd7" => :mojave
    sha256 "f5969f9baee33db8614d7fa1b54f3d923474b8516deb7f8d77f31160be174af2" => :high_sierra
    sha256 "ae46840a9d0e08909665694d161a3a8e0962a5936c523812057dc39d61eda8fd" => :sierra
    sha256 "da919a1964d6ef0633eac14bd7138ab91f6676d4dfc36fd5e27f956943714d22" => :el_capitan
    sha256 "14ae5c06eac81783ee61e3547d9de174f6742c688a254e172d7c2e566f14b426" => :yosemite
    sha256 "8479d25ddc608462c974bbc1a9fb229f6ffa99d19368fcd43f667bc6a6d8493f" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/cmatrix", "-V"
  end
end
