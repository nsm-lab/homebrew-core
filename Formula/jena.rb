class Jena < Formula
  desc "Framework for building semantic web and linked data apps"
  homepage "https://jena.apache.org/"
  url "https://archive.apache.org/dist/jena/binaries/apache-jena-3.11.0.tar.gz"
  sha256 "65916308002d02a3e83f8b1a019d9b02068be5503ca906bdddb61b6c1095e7b5"

  bottle :unneeded

  def shim_script(target)
    <<~EOS
      #!/usr/bin/env bash
      export JENA_HOME="#{libexec}"
      "$JENA_HOME/bin/#{target}" "$@"
    EOS
  end

  def install
    rm_rf "bat" # Remove Windows scripts

    prefix.install %w[LICENSE NOTICE README]
    libexec.install Dir["*"]
    Dir.glob("#{libexec}/bin/*") do |path|
      bin_name = File.basename(path)
      (bin/bin_name).write shim_script(bin_name)
    end
  end

  test do
    system "#{bin}/sparql", "--version"
  end
end
