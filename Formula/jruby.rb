class Jruby < Formula
  desc "Ruby implementation in pure Java"
  homepage "https://www.jruby.org/"
  url "https://search.maven.org/remotecontent?filepath=org/jruby/jruby-dist/9.2.7.0/jruby-dist-9.2.7.0-bin.tar.gz"
  sha256 "da7c1a5ce90015c0bafd4bca0352294e08fe1c9ec049ac51e82fe57ed50e1348"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    # Remove Windows files
    rm Dir["bin/*.{bat,dll,exe}"]

    cd "bin" do
      # Prefix a 'j' on some commands to avoid clashing with other rubies
      %w[ast rake rdoc ri testrb].each { |f| mv f, "j#{f}" }
      # Delete some unnecessary commands
      rm "gem" # gem is a wrapper script for jgem
      rm "irb" # irb is an identical copy of jirb
    end

    # Only keep the macOS native libraries
    rm_rf Dir["lib/jni/*"] - ["lib/jni/Darwin"]
    libexec.install Dir["*"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "hello\n", shell_output("#{bin}/jruby -e \"puts 'hello'\"")
  end
end
