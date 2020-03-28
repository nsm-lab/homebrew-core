class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.21.1.tar.gz"
  sha256 "c20050dc6963472c7cb7ed4621c7187e24089fa458eb68748ef9d2aae53d991f"

  bottle do
    cellar :any
    sha256 "1765b7bf67fd6eaef6b4464bfe06a0ae467165acca5dd17e78d371165a5db91a" => :mojave
    sha256 "fe67cc5adc84bb2558ad4e67c5b02bfba8b80f3a18bc036801e4c1e1d81c96eb" => :high_sierra
    sha256 "21a673797bdc3ff9c7453930499e7e29e7f1320eb4dbddec67f7127dee34a989" => :sierra
    sha256 "15e18f6bb87bd489b33f4322af5d6351e28ec805aef291d6c0df50d80fb7958d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DBUILD_QT5=ON"

    share.install "test"
    mkdir "build" do
      system "cmake", "..", "-G", "Unix Makefiles", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # Copy test files as `cqmakedb` gets confused if we just symlink them.
    test_files = (share/"test").children
    cp test_files, testpath

    system "#{bin}/cqmakedb", "-s", "./codequery.db",
                              "-c", "./cscope.out",
                              "-t", "./tags",
                              "-p"
    output = shell_output("#{bin}/cqsearch -s ./codequery.db -t info_platform")
    assert_match "info_platform", output
  end
end
