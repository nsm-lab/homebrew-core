class Quazip < Formula
  desc "C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
  homepage "https://github.com/stachenov/quazip/"
  url "https://github.com/stachenov/quazip/archive/v0.8.1.tar.gz"
  sha256 "4fda4d4248e08015b5090d0369ef9e68bdc4475aa12494f7c0f6d79e43270d14"

  bottle do
    cellar :any
    sha256 "d2dbc64b1fa7d774ce2591493d376bdbd6048e667af7a81f6b672bc0e9ec961b" => :mojave
    sha256 "37d894efeea820e30b40f4f52e8709cb723b25ac7e7e6c23a06bf768aa7c46f3" => :high_sierra
    sha256 "f098b6dd9cc67d73ea2454664bb139e1e7c85315aed66757306d0155fe7a1eaf" => :sierra
  end

  depends_on "qt"

  def install
    system "qmake", "quazip.pro", "-config", "release",
                    "PREFIX=#{prefix}", "LIBS+=-lz"
    system "make", "install"
  end

  test do
    (testpath/"test.pro").write <<~EOS
      TEMPLATE     = app
      CONFIG      += console
      CONFIG      -= app_bundle
      TARGET       = test
      SOURCES     += test.cpp
      INCLUDEPATH += #{include}
      LIBPATH     += #{lib}
      LIBS        += -lquazip
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <quazip/quazip.h>
      int main() {
        QuaZip zip;
        return 0;
      }
    EOS

    system "#{Formula["qt"].bin}/qmake", "test.pro"
    system "make"
    assert_predicate testpath/"test", :exist?, "test output file does not exist!"
    system "./test"
  end
end
