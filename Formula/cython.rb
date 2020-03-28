class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/e7/2e/aee8dfff93c7f5d20461ddcefd1da3d43bab18e1666a7777f4d9dbe94065/Cython-0.29.10.tar.gz"
  sha256 "26229570d6787ff3caa932fe9d802960f51a89239b990d275ae845405ce43857"

  bottle do
    cellar :any_skip_relocation
    sha256 "d30f717fe33554801772fca076afa926f822dfcb915e3936a93238eafd6a9bc8" => :mojave
    sha256 "6c426bbeb591d80d49393f945ad5b2c9e135a3508858ccaaf65cb48bac6a7ae4" => :high_sierra
    sha256 "6c55a1dd132aa7804cbc3283ce0bb723ca527e6d42d5bf448dddaec15f009145" => :sierra
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system "python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("python3 -c 'import package_manager'")
  end
end
