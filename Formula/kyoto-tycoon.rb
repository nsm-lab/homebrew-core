class KyotoTycoon < Formula
  desc "Database server with interface to Kyoto Cabinet"
  homepage "https://fallabs.com/kyototycoon/"
  url "https://fallabs.com/kyototycoon/pkg/kyototycoon-0.9.56.tar.gz"
  sha256 "553e4ea83237d9153cc5e17881092cefe0b224687f7ebcc406b061b2f31c75c6"
  revision 3

  bottle do
    sha256 "04d72b5c55be3c26c688eda6c0cc9f88c85855ba6fe81aa36e210fc29afe7572" => :mojave
    sha256 "ce7db5082c632bef982d5463f3a8507d786fd3bcae7f7cccf8663ab36c3571bd" => :high_sierra
    sha256 "e75c60a4417bc00d04e1f24241320329f01b0d3076de2585e92375b12c4ef31d" => :sierra
  end

  depends_on "kyoto-cabinet"
  depends_on "lua"

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-kc=#{Formula["kyoto-cabinet"].opt_prefix}",
                          "--with-lua=#{Formula["lua"].opt_prefix}"
    system "make"
    system "make", "install"
  end
end


__END__
--- a/ktdbext.h  2013-11-08 09:34:53.000000000 -0500
+++ b/ktdbext.h  2013-11-08 09:35:00.000000000 -0500
@@ -271,7 +271,7 @@
       if (!logf("prepare", "started to open temporary databases under %s", tmppath.c_str()))
         err = true;
       stime = kc::time();
-      uint32_t pid = getpid() & kc::UINT16MAX;
+      uint32_t pid = kc::getpid() & kc::UINT16MAX;
       uint32_t tid = kc::Thread::hash() & kc::UINT16MAX;
       uint32_t ts = kc::time() * 1000;
       for (size_t i = 0; i < dbnum_; i++) {
