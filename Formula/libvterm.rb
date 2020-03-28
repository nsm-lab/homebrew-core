class Libvterm < Formula
  desc "C99 library which implements a VT220 or xterm terminal emulator"
  homepage "http://www.leonerd.org.uk/code/libvterm/"
  url "http://www.leonerd.org.uk/code/libvterm/libvterm-0+bzr726.tar.gz"
  sha256 "6344eca01c02e2270348b79e033c1e0957028dbcd76bc784e8106bea9ec3029d"

  bottle do
    cellar :any
    sha256 "1498cd7e2569ad6fae59210a748c6ff099e2414bf526f2928273dd6ba3fe9651" => :mojave
    sha256 "2bab7bdb6033188210ab47cd7802f7617b8dc93f84b776ef1627360dde3d8884" => :high_sierra
    sha256 "80c31b8a19c9fba971a64f3a5058d4db2bcfc12508c296058546d088182347b5" => :sierra
  end

  depends_on "libtool" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <vterm.h>

      int main() {
        vterm_free(vterm_new(1, 1));
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lvterm", "-o", "test"
    system "./test"
  end
end
