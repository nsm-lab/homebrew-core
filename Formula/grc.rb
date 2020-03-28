class Grc < Formula
  desc "Colorize logfiles and command output"
  homepage "https://korpus.juls.savba.sk/~garabik/software/grc.html"
  url "https://github.com/garabik/grc/archive/v1.11.3.tar.gz"
  sha256 "b167babd8f073a68f5a3091f833e4036fb8d86504e746694747a3ee5048fa7a9"
  head "https://github.com/garabik/grc.git"

  bottle :unneeded

  depends_on "python"

  conflicts_with "cc65", :because => "both install `grc` binaries"

  def install
    # fix non-standard prefix installs
    inreplace ["grc", "grc.1"], "/etc", etc
    inreplace ["grcat", "grcat.1"], "/usr/local", HOMEBREW_PREFIX

    # so that the completions don't end up in etc/profile.d
    inreplace "install.sh",
      "mkdir -p $PROFILEDIR\ncp -fv grc.bashrc $PROFILEDIR", ""

    system "./install.sh", prefix, HOMEBREW_PREFIX
    etc.install "grc.bashrc"
    etc.install "grc.zsh"
    etc.install "grc.fish"
    zsh_completion.install "_grc"
  end

  # Apply the upstream fix from garabik/grc@ddc789bf to preexisting config files
  def post_install
    grc_bashrc = etc/"grc.bashrc"
    bad = /^    alias ls='colourify ls --color'$/
    if grc_bashrc.exist? && File.read(grc_bashrc) =~ bad
      inreplace grc_bashrc, bad, "    alias ls='colourify ls'"
    end
  end

  test do
    actual = pipe_output("#{bin}/grcat #{pkgshare}/conf.ls", "hello root")
    assert_equal "\e[0mhello \e[0m\e[1m\e[37m\e[41mroot\e[0m", actual.chomp
  end
end
