class Kobalt < Formula
  desc "Build system"
  homepage "https://beust.com/kobalt/"
  url "https://github.com/cbeust/kobalt/releases/download/1.0.123/kobalt-1.0.123.zip"
  sha256 "ffcd57bcccaefba4c0c577c75881f54ce1e272d417f694ff4699806ed41e929f"

  bottle :unneeded

  def install
    libexec.install "kobalt-#{version}/kobalt"

    (bin/"kobaltw").write <<~EOS
      #!/bin/bash
      java -jar #{libexec}/kobalt/wrapper/kobalt-wrapper.jar $*
    EOS
  end

  test do
    (testpath/"src/main/kotlin/com/A.kt").write <<~EOS
      package com
      class A
    EOS

    (testpath/"kobalt/src/Build.kt").write <<~EOS
      import com.beust.kobalt.*
      import com.beust.kobalt.api.*
      import com.beust.kobalt.plugin.packaging.*

      val p = project {
        name = "test"
        version = "1.0"
        assemble {
          jar {}
        }
      }
    EOS

    system "#{bin}/kobaltw", "assemble"
    output = "kobaltBuild/libs/test-1.0.jar"
    assert_predicate testpath/output, :exist?, "Couldn't find #{output}"
  end
end
