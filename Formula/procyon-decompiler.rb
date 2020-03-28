class ProcyonDecompiler < Formula
  desc "Modern decompiler for Java 5 and beyond"
  homepage "https://bitbucket.org/mstrobel/procyon/wiki/Java%20Decompiler"
  url "https://bitbucket.org/mstrobel/procyon/downloads/procyon-decompiler-0.5.34.jar"
  sha256 "ff575a42133a19a44635f2ab2808662b648a67cf5033f94dd6bad4b24335c843"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install "procyon-decompiler-#{version}.jar"
    bin.write_jar_script libexec/"procyon-decompiler-#{version}.jar", "procyon-decompiler"
  end

  test do
    fixture = <<~EOS
      class T
      {
          public static void main(final String[] array) {
              System.out.println("Hello World!");
          }
      }
    EOS
    (testpath/"T.java").write fixture
    system "javac", "T.java"
    fixture.match pipe_output("#{bin}/procyon-decompiler", "T.class")
  end
end
