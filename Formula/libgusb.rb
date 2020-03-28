class Libgusb < Formula
  desc "GObject wrappers for libusb1"
  homepage "https://github.com/hughsie/libgusb"
  url "https://people.freedesktop.org/~hughsient/releases/libgusb-0.3.0.tar.xz"
  sha256 "d8e7950f99b6ae4c3e9b8c65f3692b9635289e6cff8de40c4af41b2e9b348edc"

  bottle do
    sha256 "6015794e02472323e08e3ad746766b87b974789a2093250ae130428377085747" => :mojave
    sha256 "001522939f6a73dcd930bcf628efd514f720f2284926b6f653963175661903bd" => :high_sierra
    sha256 "fa76795dedd0180934758b8136dbbd42e34efcc1ef04c1421b17477de53ed1e6" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libusb"

  # The original usb.ids file can be found at http://www.linux-usb.org/usb.ids
  # It is updated over time and its checksum changes, we maintain a copy
  resource "usb.ids" do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/4235be3ce12f415f75869349af9a4198543f167a/simple-scan/usb.ids"
    sha256 "ceceb3759e48eaf47451d7bca81ef4174fced1d4300f9ed33e2b53ee23160c6b"
  end

  # see https://github.com/hughsie/libgusb/issues/11
  patch :DATA

  def install
    (share/"hwdata/").install resource("usb.ids")
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", "-Dusb_ids=#{share}/hwdata/usb.ids", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gusbcmd", "-h"
    (testpath/"test.c").write <<~EOS
      #include <gusb.h>

      int main(int argc, char *argv[]) {
        GUsbContext *context = g_usb_context_new(NULL);
        g_assert_nonnull(context);
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libusb = Formula["libusb"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{libusb.opt_include}/libusb-1.0
      -I#{include}/gusb-1
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{libusb.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lusb-1.0
      -lgusb
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gusb/meson.build b/gusb/meson.build
index c39a8f1..4bee8ef 100644
--- a/gusb/meson.build
+++ b/gusb/meson.build
@@ -37,8 +37,6 @@ install_headers([
   subdir : 'gusb-1/gusb',
 )

-mapfile = 'libgusb.ver'
-vflag = '-Wl,--version-script,@0@/@1@'.format(meson.current_source_dir(), mapfile)
 gusb = shared_library(
   'gusb',
   sources : [
@@ -62,8 +60,6 @@ gusb = shared_library(
       root_incdir,
       lib_incdir,
   ],
-  link_args : vflag,
-  link_depends : mapfile,
   install : true
 )
