class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://etsh.nl/"
  url "https://etsh.nl/src/etsh_5.3.1/etsh-5.3.1.tar.xz"
  sha256 "83ae656da0ed39555818d3ac80841757672e55802632f6877037bc89a476ec2b"
  version_scheme 1

  bottle do
    sha256 "ee5cb69606c9c472cf0ab618e886a0f238a9e044d49cc54d97d4d806e58738c5" => :mojave
    sha256 "875b9f0c5cd602f8a40b31d2eb7134a3fe045c0d53a5535b4b8ab5ab4cf09806" => :high_sierra
    sha256 "31219a25086c96ac502d6def1dd108dcf815f62a4a204248a10cbc698b1ab75a" => :sierra
  end

  conflicts_with "teleport", :because => "both install `tsh` binaries"

  def install
    system "./configure"
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}", "MANDIR=#{man1}"
    bin.install_symlink "etsh" => "osh"
    bin.install_symlink "tsh" => "sh6"
  end

  test do
    assert_match "brew!", shell_output("#{bin}/etsh -c 'echo brew!'").strip
  end
end
