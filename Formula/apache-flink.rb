class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https://flink.apache.org/"
  url "https://archive.apache.org/dist/flink/flink-1.8.1/flink-1.8.1-bin-scala_2.11.tgz"
  version "1.8.1"
  sha256 "4fc0d0f163174ec43e160fdf21a91674979b978793e60361e2fce5dddba4ddfa"
  head "https://github.com/apache/flink.git"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    rm_f Dir["bin/*.bat"]
    libexec.install Dir["*"]
    (libexec/"bin").env_script_all_files(libexec/"libexec", Language::Java.java_home_env("1.8"))
    chmod 0755, Dir["#{libexec}/bin/*"]
    bin.write_exec_script "#{libexec}/bin/flink"
  end

  test do
    (testpath/"log").mkpath
    (testpath/"input").write "foo bar foobar"
    expected = <<~EOS
      (foo,1)
      (bar,1)
      (foobar,1)
    EOS
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    ENV.prepend "FLINK_LOG_DIR", testpath/"log"
    system libexec/"bin/start-cluster.sh"
    system bin/"flink", "run", "-p", "1",
           libexec/"examples/streaming/WordCount.jar", "--input", "input",
           "--output", "result"
    system libexec/"bin/stop-cluster.sh"
    assert_predicate testpath/"result", :exist?
    assert_equal expected, (testpath/"result").read
  end
end
