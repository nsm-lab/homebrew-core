class Libdca < Formula
  desc "Library for decoding DTS Coherent Acoustics streams"
  homepage "https://www.videolan.org/developers/libdca.html"
  url "https://download.videolan.org/pub/videolan/libdca/0.0.6/libdca-0.0.6.tar.bz2"
  sha256 "98f98a9aa000a26b927c6facd15d18dcf664238adfc5db24f533c5932cdb1f40"

  bottle do
    cellar :any
    sha256 "9fb6a391e9e872a2208e5d5a259e5c41b700ffc1b8cd893f642814a83a42c5b8" => :mojave
    sha256 "9b4fb37c6557a891de3aeec0f79dce74031af488207f6f1170c57c8d3c6f863b" => :high_sierra
    sha256 "9db0e0e2662aa86d8c8417d13669e1b7cd0d599afede76178f7fbbd0dd3b4b7b" => :sierra
    sha256 "641d1810fd6ca84d49824335403d79a8834611d1dd615d93300989040135ed1d" => :el_capitan
  end

  def install
    # Fixes "duplicate symbol ___sputc" error when building with clang
    # https://github.com/Homebrew/homebrew/issues/31456
    ENV.append_to_cflags "-std=gnu89"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
