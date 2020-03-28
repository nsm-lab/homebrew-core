class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "https://zim-wiki.org/"
  url "https://github.com/jaap-karssenberg/zim-desktop-wiki/archive/0.71.1.tar.gz"
  sha256 "ff100188a0b7204b415394d849b91954970449ee81fc99e4aea49b347a0a2112"
  head "https://github.com/jaap-karssenberg/zim-desktop-wiki.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e764946bb090836984660210b0bfaee1fcca2d38bcec56f06b10df15bd067c40" => :mojave
    sha256 "e764946bb090836984660210b0bfaee1fcca2d38bcec56f06b10df15bd067c40" => :high_sierra
    sha256 "ca0b8cb859f7f3c39af5b2fda1ae4d5a5c85aa4c82aad41b92639cb436985b16" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "graphviz"
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "pygtk"
  depends_on "pygtksourceview"
  depends_on "python"

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/47/6e/311d5f22e2b76381719b5d0c6e9dc39cd33999adae67db71d7279a6d70f4/pyxdg-0.26.tar.gz"
    sha256 "fe2928d3f532ed32b39c32a482b54136fe766d19936afc96c8f00645f9da1a06"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python3.7/site-packages"
    resource("pyxdg").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end
    ENV["XDG_DATA_DIRS"] = libexec/"share"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python3.7/site-packages"
    system "python3", "./setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"], :XDG_DATA_DIRS => libexec/"share"
    pkgshare.install "zim"
  end

  test do
    system "#{bin}/zim", "--version"
  end
end
