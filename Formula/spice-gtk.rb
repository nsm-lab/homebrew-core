class SpiceGtk < Formula
  desc "GTK client/libraries for SPICE"
  homepage "https://www.spice-space.org"
  url "https://www.spice-space.org/download/gtk/spice-gtk-0.37.tar.bz2"
  sha256 "1f28b706472ad391cda79a93fd7b4c7a03e84b88fc46ddb35dddbe323c923bb7"

  bottle do
    sha256 "2af8aeb54caf808c2714911e21645804e97c2e4e483188285349a5fb1db90f62" => :mojave
    sha256 "3b8016d7bbe6a3d92b1da5c4783b527fda4e8070782ec32eaeb74af31945ad4d" => :high_sierra
    sha256 "a0b7ef075bbbc7d4b67b8e6462b55717ac97703d3456a3ccdb599f1b5892b3a8" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "autogen" => :build
  depends_on "automake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build

  depends_on "atk"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gst-libav"
  depends_on "gst-plugins-bad"
  depends_on "gst-plugins-base"
  depends_on "gst-plugins-good"
  depends_on "gst-plugins-ugly"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libusb"
  depends_on "lz4"
  depends_on "openssl"
  depends_on "opus"
  depends_on "pango"
  depends_on "pixman"
  depends_on "spice-protocol"
  depends_on "usbredir"

  # Upstream patch: https://gitlab.freedesktop.org/spice/spice-gtk/issues/88
  patch do
    url "https://gitlab.freedesktop.org/spice/spice-gtk/commit/3c9b37bfc7c88969dfe16b8bfd874745e0fceb8a.diff"
    sha256 "c2bb9c6dc0d07f333d10077987386680818296f1deb3b796ea7e35453aba7d91"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-introspection
      --enable-gstvideo
      --enable-gstaudio
      --enable-gstreamer=1.0
      --enable-vala
      --with-coroutine=gthread
      --with-gtk=3.0
      --with-lz4
      --prefix=#{prefix}
    ]
    system "autoreconf"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spice-client.h>
      #include <spice-client-gtk.h>
      int main() {
        return spice_session_new() ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["atk"].include}/atk-1.0",
                   "-I#{Formula["cairo"].include}/cairo",
                   "-I#{Formula["gdk-pixbuf"].include}/gdk-pixbuf-2.0",
                   "-I#{Formula["glib"].include}/glib-2.0",
                   "-I#{Formula["glib"].lib}/glib-2.0/include",
                   "-I#{Formula["gtk+3"].include}/gtk-3.0",
                   "-I#{Formula["pango"].include}/pango-1.0",
                   "-I#{Formula["spice-protocol"].include}/spice-1",
                   "-I#{include}/spice-client-glib-2.0",
                   "-I#{include}/spice-client-gtk-3.0",
                   "-L#{lib}",
                   "-lspice-client-glib-2.0",
                   "-lspice-client-gtk-3.0",
                   "-o", "test"
    system "./test"
  end
end
