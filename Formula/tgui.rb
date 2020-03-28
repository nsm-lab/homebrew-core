class Tgui < Formula
  desc "GUI library for use with sfml"
  homepage "https://tgui.eu"
  url "https://github.com/texus/TGUI/archive/v0.8.5.tar.gz"
  sha256 "10d3cc3747acc6c5d7e4fd7de2e56fb63c4af6741f51dae825bf69267a3c8479"

  bottle do
    cellar :any
    sha256 "bb4cb1abbe054e3a6111a1b6c6f94542dda6de5ed2a090b5089f1b7248d04aad" => :mojave
    sha256 "811a11b144eaf8cd53701b61529cfe3429f5d2b25846ff861318375c180f10af" => :high_sierra
    sha256 "28ccab66f83240703d4778a408576be56b1a212c520419b35bc9330c70ea5cee" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DTGUI_MISC_INSTALL_PREFIX=#{pkgshare}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <TGUI/TGUI.hpp>
      int main()
      {
        sf::Text text;
        text.setString("Hello World");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}",
      "-L#{lib}", "-L#{Formula["sfml"].opt_lib}",
      "-ltgui", "-lsfml-graphics", "-lsfml-system", "-lsfml-window",
      "-o", "test"
    system "./test"
  end
end
