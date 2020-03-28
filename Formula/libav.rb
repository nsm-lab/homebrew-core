class Libav < Formula
  desc "Audio and video processing tools"
  homepage "https://libav.org/"
  url "https://libav.org/releases/libav-12.3.tar.xz"
  sha256 "6893cdbd7bc4b62f5d8fd6593c8e0a62babb53e323fbc7124db3658d04ab443b"
  revision 2
  head "https://git.libav.org/libav.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7cdb84c6fc90873040d71b19dbe1eb618d0f8dcec9a886500f983b7faaa163d0" => :mojave
    sha256 "a366d17a48d20315e20dc391357f4936c9f5ec80c3dba94da417b64d8d7e7d0d" => :high_sierra
    sha256 "7625aeaf88043a02112a90c26a0813fc3e3104aa29862fddb2e52caadf97046b" => :sierra
  end

  depends_on "pkg-config" => :build
  # manpages won't be built without texi2html
  depends_on "texi2html" => :build
  depends_on "yasm" => :build

  depends_on "faac"
  depends_on "fdk-aac"
  depends_on "freetype"
  depends_on "lame"
  depends_on "libvorbis"
  depends_on "libvpx"
  depends_on "opus"
  depends_on "sdl"
  depends_on "theora"
  depends_on "x264"
  depends_on "xvid"

  # https://bugzilla.libav.org/show_bug.cgi?id=1033
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/b6e917c/libav/Check-for--no_weak_imports-in-ldflags-on-macOS.patch"
    sha256 "986d748ba2c7c83319a59d76fbb0dca22dcd51f0252b3d1f3b80dbda2cf79742"
  end

  # Upstream patch for x264 version >= 153, should be included in libav > 12.3
  patch do
    url "https://github.com/libav/libav/commit/c6558e8840fbb2386bf8742e4d68dd6e067d262e.patch?full_index=1"
    sha256 "0fcfe69274cccbca33825414f526300a1fbbf0c464ac32577e1cc137b8618820"
  end

  # Upstream patch to fix building with fdk-aac 2
  patch do
    url "https://github.com/libav/libav/commit/141c960e21d2860e354f9b90df136184dd00a9a8.patch?full_index=1"
    sha256 "7081183fed875f71d53cce1e71f6b58fb5d5eee9f30462d35f9367ec2210507b"
  end

  def install
    args = %W[
      --disable-debug
      --disable-shared
      --disable-indev=jack
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cflags=#{ENV.cflags}
      --host-ldflags=#{ENV.ldflags}
      --enable-gpl
      --enable-libfaac
      --enable-libfdk-aac
      --enable-libfreetype
      --enable-libmp3lame
      --enable-libopus
      --enable-libvorbis
      --enable-libvpx
      --enable-libx264
      --enable-libxvid
      --enable-nonfree
      --enable-vda
      --enable-version3
      --enable-libtheora
    ]

    system "./configure", *args
    system "make"

    bin.install "avconv", "avprobe", "avplay"
    man1.install "doc/avconv.1", "doc/avprobe.1", "doc/avplay.1"
  end

  test do
    # Create an example mp4 file
    system "#{bin}/avconv", "-y", "-filter_complex",
        "testsrc=rate=1:duration=1", "#{testpath}/video.mp4"
    assert_predicate testpath/"video.mp4", :exist?
  end
end
