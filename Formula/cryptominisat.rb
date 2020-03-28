class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.6.8.tar.gz"
  sha256 "38add382c2257b702bdd4f1edf73544f29efc6e050516b6cacd2d81e35744b55"

  bottle do
    sha256 "8c68cbd0307ceddc6a3ba70f488ed4ebb43b9d649cf1df3eb75788b3a5c58e3c" => :mojave
    sha256 "7be2c4e5ace97acdf39f6a4941fd601cb777e1d0c58117f11ab9b2711ba19fae" => :high_sierra
    sha256 "4633506d240ca8298bf26b6f48985c4e04877091abae50f20413f974fbb2bbbd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :arch => :x86_64
  depends_on "boost"
  depends_on "python"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DNOM4RI=ON"
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match /s UNSATISFIABLE/, result
  end
end
