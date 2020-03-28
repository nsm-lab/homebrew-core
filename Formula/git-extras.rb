class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/4.7.0.tar.gz"
  sha256 "58ed54248a1efcb8e9981940040361343e175cb36f72adc61896d53a8b234b5d"
  head "https://github.com/tj/git-extras.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8a718b1c0fcba2990489bedc99d2fb42416f41178627766f777428c7b4ec361" => :mojave
    sha256 "a8a718b1c0fcba2990489bedc99d2fb42416f41178627766f777428c7b4ec361" => :high_sierra
    sha256 "87052e2cda514c6664caf19ad9bb7f25d158120295b930b220b5f444c85a94d3" => :sierra
  end

  conflicts_with "git-utils",
    :because => "both install a `git-pull-request` script"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALL_VIA=brew", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats; <<~EOS
    To load Zsh completions, add the following to your .zschrc:
      source #{opt_pkgshare}/git-extras-completion.zsh
  EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end
