require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.6.3.tgz"
  sha256 "e5f5f08854cb821d6196fe7b438b80372c67be16eb0f45c6ea22b5b741379dcd"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85f149b9eb5f0e49bff30e9af4a465c9dd768500c27061198225bbdc42e47315" => :mojave
    sha256 "91a544105a3ab68142b455117c91276ab5632ad80daa6cca34aa80800093213e" => :high_sierra
    sha256 "3c7eac58fecbcfb14c9d3d1c0a89ba065fb8f773fff6953a9a925c8b453e6e63" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<~EOS
      /**
       * Represents a formula.
       * @constructor
       * @param {string} name - the name of the formula.
       * @param {string} version - the version of the formula.
       **/
      function Formula(name, version) {}
    EOS

    system bin/"jsdoc", "--verbose", "test.js"
  end
end
