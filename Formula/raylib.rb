class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/2.5.0.tar.gz"
  sha256 "fa947329975bdc9ea284019f0edc30ca929535dc78dcf8c19676900d67a845ac"
  head "https://github.com/raysan5/raylib.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "b508af6172e24861365bda6e94731576c0b0ec6f540782e46271c23d35028878" => :mojave
    sha256 "c8410a481ccadaa944ca296a81f6924731c5201cb3a2b279cf436c044a0310ba" => :high_sierra
    sha256 "9d40a34b711a48fe4a32b03fc709ce96318111f1ab6f6216f6bd154ac09d4bc5" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DSTATIC_RAYLIB=ON",
                         "-DSHARED_RAYLIB=ON",
                         "-DMACOS_FATLIB=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_GAMES=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <raylib.h>
      int main(void)
      {
          int num = GetRandomValue(42, 1337);
          return 42 <= num && num <= 1337 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lraylib", "-o", "test"
    system "./test"
  end
end
