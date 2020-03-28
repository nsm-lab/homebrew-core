class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v0.14.5.tar.gz"
  sha256 "4dbc4998e2c630ee7758544de4286c70c68e639524b6088ccdc7b5487c928695"
  head "https://github.com/gosu/gosu.git"

  bottle do
    cellar :any
    sha256 "d2b121b69379f97ef3fc413970b1bd4355c049703342b66fb661ebce4cc6aa75" => :mojave
    sha256 "9aade349ed7409b4a8409f69d8a21b9b3c994095c4762e347783d9fd92b287ff" => :high_sierra
    sha256 "6e3ceaff76704fa5095d2d6a9f4306a566909da22d52bf2a0d49bd847d638f5e" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    mkdir "build" do
      system "cmake", "../cmake", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480)
          {
              set_caption(\"Hello World!\");
          }

          void update()
          {
              exit(0);
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++11"
    system "./test"
  end
end
