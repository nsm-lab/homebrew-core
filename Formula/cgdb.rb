class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "https://cgdb.me/files/cgdb-0.7.0.tar.gz"
  sha256 "bf7a9264668db3f9342591b08b2cc3bbb08e235ba2372877b4650b70c6fb5423"
  revision 1

  bottle do
    sha256 "61bf2feb99d9f787ca7f31054732161fbce069e7bb2d586bc498021890de625e" => :mojave
    sha256 "5d7640abe0c061f425b299202885c1540352efacf7a0be63dda9047965ec1cb1" => :high_sierra
    sha256 "ae319df2221718b4b69238cc8b73e201350b4a8260d0c4b6ac7e1608cb4669d6" => :sierra
  end

  head do
    url "https://github.com/cgdb/cgdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "help2man" => :build
  depends_on "readline"

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cgdb", "--version"
  end
end
