class GnuChess < Formula
  desc "GNU Chess"
  homepage "https://www.gnu.org/software/chess/"
  url "https://ftp.gnu.org/gnu/chess/gnuchess-6.2.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/chess/gnuchess-6.2.5.tar.gz"
  sha256 "9a99e963355706cab32099d140b698eda9de164ebce40a5420b1b9772dd04802"
  revision 1

  bottle do
    sha256 "38957b9b332c27f5952ff0f5cc38d08c58a6578ef358974fb1f7860a13d12f60" => :mojave
    sha256 "f66f7a33aa5d6901cdaa888ab0a5e8b6e0f49649dbbf86c7c3ff48568c0e0a89" => :high_sierra
    sha256 "17d6cd58b1c4157c70bb1417824ec96a161bae4f5ff1544f4d1044f03f0e95a0" => :sierra
  end

  head do
    url "https://svn.savannah.gnu.org/svn/chess/trunk"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "help2man" => :build
    depends_on "gettext"
  end

  depends_on "readline"

  resource "book" do
    url "https://ftp.gnu.org/gnu/chess/book_1.02.pgn.gz"
    sha256 "deac77edb061a59249a19deb03da349cae051e52527a6cb5af808d9398d32d44"
  end

  def install
    if build.head?
      system "autoreconf", "--install"
      chmod 0755, "install-sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    resource("book").stage do
      doc.install "book_1.02.pgn"
    end
  end

  def caveats; <<~EOS
    This formula also downloads the additional opening book.  The
    opening book is a PGN file located in #{doc} that can be added
    using gnuchess commands.
  EOS
  end

  test do
    assert_equal "GNU Chess #{version}", shell_output("#{bin}/gnuchess --version").chomp
  end
end
