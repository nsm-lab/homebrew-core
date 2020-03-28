class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v1.1.0.tar.gz"
  sha256 "7135e8faac75f28e83b8098bcc7a5c36fc430e7c4e17729e785392ad365dfd7d"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd34ce68912ccb856a143f314080dec53992714d956cc05546dd94552b58d5b2" => :mojave
    sha256 "1518adfd6aa39659841fc6193b298e4571c7a6e588f7f15e73dd1f12d7e5cb4f" => :high_sierra
    sha256 "ea6abac30a504eadac6017fde6c26272f4bcc39baf44ae78d1b69a1f2e1ac99c" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=pbcopy"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn sh
      set timeout 1
      send "echo key=value | #{bin}/yank -d = | cat"
      send "\r"
      send "\016"
      send "\r"
      expect {
            "value" { send "exit\r"; exit 0 }
            timeout { send "exit\r"; exit 1 }
      }
    EOS
    system "expect", "-f", "test.exp"
  end
end
