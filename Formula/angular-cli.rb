require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.1.2.tgz"
  sha256 "370b6e17dd24d33460248236a5de64f24dbeb0da07220ead731af20b3b01ea3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fbeaa825b6345ff0daf3812c9a9511d6313a381f399293282a5e5995241a222" => :mojave
    sha256 "f76f8ed73d8f0ef1431d828e783af97574ca492c157a2a69def0cee416dfc27c" => :high_sierra
    sha256 "5e38c6590a833c0e45c621607c65d4023def4b4f84e6503c3bd9c9d164db2d00" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
