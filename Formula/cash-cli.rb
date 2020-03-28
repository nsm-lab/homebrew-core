require "language/node"

class CashCli < Formula
  desc "Exchange Currency Rates using your terminal"
  homepage "https://github.com/xxczaki/cash-cli"
  url "https://registry.npmjs.org/cash-cli/-/cash-cli-3.0.0.tgz"
  sha256 "35990d2763a62bc08cb1f8c2aa0730b4463d41c84483cb40514ed418d3dc4283"

  bottle do
    cellar :any_skip_relocation
    sha256 "f36142488dbc8a3a192d695b8f64e8772740c44fec4660dc8d655e62d269cb97" => :mojave
    sha256 "fa9e3e47fa5b8422b2293c45ac616e4da32e6fcd879127651562a44301f06a47" => :high_sierra
    sha256 "6a30fe3214d0241ff1f8a65582077cc7d6132987e839cd4028494b3b83a4f520" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Saved API key to", shell_output("#{bin}/cash --key foo")
  end
end
