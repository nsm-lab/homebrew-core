class OpentracingCpp < Formula
  desc "OpenTracing API for C++"
  homepage "https://opentracing.io/"
  url "https://github.com/opentracing/opentracing-cpp/archive/v1.5.1.tar.gz"
  sha256 "015c4187f7a6426a2b5196f0ccd982aa87f010cf61f507ae3ce5c90523f92301"

  bottle do
    cellar :any
    sha256 "db04cd1a4d2e9a371d45a600e7f225381581e033a18df17cca658d6e98888878" => :mojave
    sha256 "940e0c80b1d95e0597b4dd590c1d1149bcdb3de36d05f9a22ba257e6f0db2227" => :high_sierra
    sha256 "327b16eea15c233bbe7822616b485efe899591a3d43bf56606e605cbb336f2b2" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    pkgshare.install "example/tutorial/tutorial-example.cpp"
    pkgshare.install "example/tutorial/text_map_carrier.h"
  end

  test do
    system ENV.cxx, "#{pkgshare}/tutorial-example.cpp", "-std=c++11", "-L#{lib}", "-I#{include}", "-lopentracing", "-lopentracing_mocktracer", "-o", "tutorial-example"
    system "./tutorial-example"
  end
end
