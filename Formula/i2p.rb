class I2p < Formula
  desc "Anonymous overlay network - a network within a network"
  homepage "https://geti2p.net"
  url "https://download.i2p2.de/releases/0.9.39/i2pinstall_0.9.39.jar"
  mirror "https://launchpad.net/i2p/trunk/0.9.39/+download/i2pinstall_0.9.39.jar"
  sha256 "da5a5f094c6a6b0eb54f1233c1a8af0f1e0fc6a2fdb822a2ae3edbf47fca8c44"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    (buildpath/"path.conf").write "INSTALL_PATH=#{libexec}"

    system "java", "-jar", "i2pinstall_#{version}.jar", "-options", "path.conf"

    wrapper_name = "i2psvc-macosx-universal-64"
    libexec.install_symlink libexec/wrapper_name => "i2psvc"
    bin.write_exec_script Dir["#{libexec}/{eepget,i2prouter}"]
    man1.install Dir["#{libexec}/man/*"]
  end

  test do
    assert_match "I2P Service is not running.", shell_output("#{bin}/i2prouter status", 1)
  end
end
