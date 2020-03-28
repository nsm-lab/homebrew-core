class Gitfs < Formula
  include Language::Python::Virtualenv

  desc "Version controlled file system"
  homepage "https://www.presslabs.com/gitfs"
  url "https://github.com/PressLabs/gitfs/archive/0.4.5.1.tar.gz"
  sha256 "6049fd81182d9172e861d922f3e2660f76366f85f47f4c2357f769d24642381c"
  revision 4
  head "https://github.com/PressLabs/gitfs.git"

  bottle do
    cellar :any
    sha256 "7859077b249dd271735ef57f6472aefec42708ed8efafc472f81ff31e77d0726" => :mojave
    sha256 "9f70c9b930752bc09c7f141b7a77990ed96b9dd995c087f6b861831e249830a2" => :high_sierra
    sha256 "5a85dbfb02e93e66495b512a10348242f7e6380d690af2aebc8bd4b48d2e0f22" => :sierra
  end

  depends_on "libgit2"
  depends_on :osxfuse
  depends_on "python"

  resource "atomiclong" do
    url "https://files.pythonhosted.org/packages/86/8c/70aea8215c6ab990f2d91e7ec171787a41b7fbc83df32a067ba5d7f3324f/atomiclong-0.1.1.tar.gz"
    sha256 "cb1378c4cd676d6f243641c50e277504abf45f70f1ea76e446efcdbb69624bbe"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "fusepy" do
    url "https://files.pythonhosted.org/packages/70/aa/959d781b7ac979af1a9fbea0faffe06677c390907b56b8ce024eb9320451/fusepy-2.0.4.tar.gz"
    sha256 "10f5c7f5414241bffecdc333c4d3a725f1d6605cae6b4eaf86a838ff49cdaf6c"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/ec/56/9f591bee962dcdc3c4268c4bf0a836d5188b1604e58e3618df12a963573b/pygit2-0.28.1.tar.gz"
    sha256 "2ccdb865ef530c799a6430d0e52952925ffc0d7c856e7608f4cf42f4b821412b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<~EOS
    gitfs clones repos in /var/lib/gitfs. You can either create it with
    sudo mkdir -m 1777 /var/lib/gitfs or use another folder with the
    repo_path argument.

    Also make sure OSXFUSE is properly installed by running brew info osxfuse.
  EOS
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    (testpath/"test.py").write <<~EOS
      import gitfs
      import pygit2
      pygit2.init_repository('testing/.git', True)
    EOS

    system "python3", "test.py"
    assert_predicate testpath/"testing/.git/config", :exist?
    cd "testing" do
      system "git", "remote", "add", "homebrew", "https://github.com/Homebrew/homebrew.git"
      assert_match "homebrew", shell_output("git remote")
    end
  end
end
