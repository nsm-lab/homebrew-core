class Falcon < Formula
  desc "Multi-paradigm programming language and scripting engine"
  homepage "http://www.falconpl.org/"
  url "https://mirrorservice.org/sites/distfiles.macports.org/falcon/Falcon-0.9.6.8.tgz"
  mirror "https://src.fedoraproject.org/repo/pkgs/Falcon/Falcon-0.9.6.8.tgz/8435f6f2fe95097ac2fbe000da97c242/Falcon-0.9.6.8.tgz"
  sha256 "f4b00983e7f91a806675d906afd2d51dcee048f12ad3af4b1dadd92059fa44b9"

  bottle do
    rebuild 1
    sha256 "f9741251c89c441ae25ada11413ae31e988f00f84ddc05b80549d62fd2db31a4" => :mojave
    sha256 "6349ea1828c7474157a6bac4131c4ac952aba1330014ffd92efeaecc6ebe486f" => :high_sierra
    sha256 "560217a0114fb31f303271eb925da7959d8e02fb8e3d118c0ea449f34ddd3e7b" => :sierra
    sha256 "48f3fc7a4ee3f479b0dafae18262cb900d64f43f5a3f2fa32727b65f6836f81e" => :el_capitan
    sha256 "e5dc11f9529c43c216dc304df212eab022ce654fc551ad244a291a6b861931b8" => :yosemite
    sha256 "bf2a677c2d6777b577bffc22d3c75a65525700bef6478035dececa002e5e11ec" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pcre"

  conflicts_with "sdl",
    :because => "Falcon optionally depends on SDL and then the build breaks. Fix it!"

  def install
    args = std_cmake_args + %W[
      -DFALCON_BIN_DIR=#{bin}
      -DFALCON_LIB_DIR=#{lib}
      -DFALCON_MAN_DIR=#{man1}
      -DFALCON_WITH_EDITLINE=OFF
      -DFALCON_WITH_FEATHERS=NO
      -DFALCON_WITH_INTERNAL_PCRE=OFF
      -DFALCON_WITH_MANPAGES=ON
    ]

    system "cmake", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      looper = .[brigade
         .[{ val, text => oob( [val+1, "Changed"] ) }
           { val, text => val < 10 ? oob(1): "Homebrew" }]]
      final = looper( 1, "Original" )
      > "Final value is: ", final
    EOS

    assert_match(/Final value is: Homebrew/,
                 shell_output("#{bin}/falcon test").chomp)
  end
end
