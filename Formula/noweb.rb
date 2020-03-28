class Noweb < Formula
  desc "WEB-like literate-programming tool"
  homepage "https://www.cs.tufts.edu/~nr/noweb/"
  # new canonical url (for newer versions): http://mirrors.ctan.org/web/noweb.zip
  url "https://deb.debian.org/debian/pool/main/n/noweb/noweb_2.11b.orig.tar.gz"
  sha256 "c913f26c1edb37e331c747619835b4cade000b54e459bb08f4d38899ab690d82"

  bottle do
    cellar :any_skip_relocation
    sha256 "e37f2dd197cbd312c8635ab73e92d904b1d02d485879aac2077b5361986fcc0f" => :mojave
    sha256 "7d794eab58f440c640358ba7454f04f007b26b3b35a0d19acec1915c97c25c5b" => :high_sierra
    sha256 "3235ad9e73a3371058c59319f6c2363444e66e1c43e9576af3e08e14dfca682b" => :sierra
    sha256 "1a3ec7b1f7fba58e0d8064d279d518d69e50b1f813284792deb6b7db702eae38" => :el_capitan
    sha256 "34dd66401fe717e1ed384114d7037ea7a6e0aaabe6f2a98f314c8d6bb41c25be" => :yosemite
    sha256 "54bf1e45409d1c022d08dee3a43c4e2d7f038a646f00a5d5f2f6db90ff54d668" => :mavericks
  end

  depends_on "icon"

  def texpath
    prefix/"tex/generic/noweb"
  end

  def install
    cd "src" do
      system "bash", "awkname", "awk"
      system "make LIBSRC=icon ICONC=icont CFLAGS='-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=1'"

      bin.mkpath
      lib.mkpath
      man.mkpath
      texpath.mkpath

      system "make", "install", "BIN=#{bin}",
                                "LIB=#{lib}",
                                "MAN=#{man}",
                                "TEXINPUTS=#{texpath}"
      cd "icon" do
        system "make", "install", "BIN=#{bin}",
                                  "LIB=#{lib}",
                                  "MAN=#{man}",
                                  "TEXINPUTS=#{texpath}"
      end
    end
  end

  def caveats; <<~EOS
    TeX support files are installed in the directory:

      #{texpath}

    You may need to add the directory to TEXINPUTS to run noweb properly.
  EOS
  end

  test do
    (testpath/"test.nw").write <<~EOS
      \section{Hello world}

      Today I awoke and decided to write
      some code, so I started to write Hello World in \textsf C.

      <<hello.c>>=
      /*
        <<license>>
      */
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("Hello World!\n");
        return 0;
      }
      @
      \noindent \ldots then I did the same in PHP.

      <<hello.php>>=
      <?php
        /*
        <<license>>
        */
        echo "Hello world!\n";
      ?>
      @
      \section{License}
      Later the same day some lawyer reminded me about licenses.
      So, here it is:

      <<license>>=
      This work is placed in the public domain.
    EOS
    assert_match "this file was generated automatically by noweave",
                 shell_output("#{bin}/noweave -filter l2h -index -html test.nw | #{bin}/htmltoc")
  end
end
