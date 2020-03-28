class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2019.01.20/kakoune-2019.01.20.tar.bz2"
  sha256 "991103a227be00ca1b10ad575fd6c749fa4c99eb19763971c7b1e113e299b995"
  head "https://github.com/mawww/kakoune.git"

  bottle do
    cellar :any
    sha256 "898cd671f9407a36f4f0a039113251fcb0c18839415b25067de7b823cbcf7122" => :mojave
    sha256 "a5992a3e250758a4026927218c78b387cc7054de11353f59c28278f2236a8e17" => :high_sierra
    sha256 "225f222b1abe79c31cfaebf60756eef4f47d79a365e75c03261e143f21ea52af" => :sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "ncurses"

  if MacOS.version <= :el_capitan
    depends_on "gcc"
    fails_with :clang do
      build 800
      cause "New C++ features"
    end
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
