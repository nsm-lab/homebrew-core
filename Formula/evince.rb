class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/3.32/evince-3.32.0.tar.xz"
  sha256 "f0d977216466ed2f5a6de64476ef7113dc7c7c9832336f1ff07f3c03c5324c40"

  bottle do
    sha256 "8d1fb23658da65d47d29adb98a07332168d5b5ec8be5d29069c43f88e1e55c64" => :mojave
    sha256 "152c9214046e061a7d38ad88abe6dfde92b9e297993a459eed5ae5851be47381" => :high_sierra
    sha256 "d46efcdeb3c0988bd477e83bcd67466c7f3000cb538e4d9fc9661bd8e3c0626d" => :sierra
  end

  depends_on "appstream-glib" => :build
  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "libxml2"
  depends_on "poppler"
  depends_on "python"

  # patch submitted upstream at https://gitlab.gnome.org/GNOME/evince/merge_requests/154
  patch :DATA

  def install
    ENV["GETTEXTDATADIR"] = "#{Formula["appstream-glib"].opt_share}/gettext"

    # Fix build failure "ar: illegal option -- D"
    # Reported 15 Sep 2017 https://bugzilla.gnome.org/show_bug.cgi?id=787709
    inreplace "configure", "AR_FLAGS=crD", "AR_FLAGS=r"

    # Add MacOS mime-types to the list of supported comic book archive mime-types
    # Submitted upstream at https://gitlab.gnome.org/GNOME/evince/merge_requests/157
    inreplace "configure", "COMICS_MIME_TYPES=\"",
      "COMICS_MIME_TYPES=\"application/x-rar;application/zip;application/x-cb7;application/x-7z-comperssed;application/x-tar;"

    # forces use of gtk3-update-icon-cache instead of gtk-update-icon-cache. No bugreport should
    # be filed for this since it only occurs because Homebrew renames gtk+3's gtk-update-icon-cache
    # to gtk3-update-icon-cache in order to avoid a collision between gtk+ and gtk+3.
    inreplace "data/Makefile.in", "gtk-update-icon-cache", "gtk3-update-icon-cache"

    xy = Language::Python.major_minor_version "python3"
    ENV.append_path "PYTHONPATH", "#{Formula["libxml2"].opt_lib}/python#{xy}/site-packages"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-nautilus",
                          "--disable-schemas-compile",
                          "--enable-introspection",
                          "--enable-djvu",
                          "--disable-browser-plugin"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end

__END__
diff --git a/libdocument/ev-document-factory.c b/libdocument/ev-document-factory.c
index ca1aeeb..4f7f40b 100644
--- a/libdocument/ev-document-factory.c
+++ b/libdocument/ev-document-factory.c
@@ -58,8 +58,12 @@ get_backend_info_for_mime_type (const gchar *mime_type)
                 guint i;

                 for (i = 0; mime_types[i] != NULL; ++i) {
-                        if (g_content_type_is_mime_type (mime_type, mime_types[i]))
+                        gchar *content_type = g_content_type_from_mime_type(mime_type);
+                        if (g_content_type_is_mime_type (content_type, mime_types[i])) {
+                                g_free(content_type);
                                 return info;
+                        }
+                        g_free(content_type);
                 }
         }
