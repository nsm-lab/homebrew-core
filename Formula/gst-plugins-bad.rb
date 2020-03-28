class GstPluginsBad < Formula
  desc "GStreamer plugins less supported, not fully tested"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.16.0.tar.xz"
  sha256 "22139de35626ada6090bdfa3423b27b7fc15a0198331d25c95e6b12cb1072b05"
  revision 2

  bottle do
    sha256 "4fbc64ef9c2971f113d0eebe1b71c2486177809bfd9bb6bc643c6506a0f00685" => :mojave
    sha256 "500abc96426a01fea66df85a2654e11101b63719f137a62beead873200fafb15" => :high_sierra
    sha256 "bfb30eca3d04c91d48f182b486b2a7a0ce716698230216c08f409f3d8a0cf4b0" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/gstreamer/gst-plugins-bad.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "faac"
  depends_on "faad2"
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "jpeg"
  depends_on "libmms"
  depends_on "libnice"
  depends_on "openssl"
  depends_on "opus"
  depends_on "orc"
  depends_on "srtp"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-yadif
      --disable-examples
      --disable-debug
      --disable-dependency-tracking
      --enable-introspection=yes
    ]

    if build.head?
      # autogen is invoked in "stable" build because we patch configure.ac
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin dvbsuboverlay")
    assert_match version.to_s, output
  end
end
