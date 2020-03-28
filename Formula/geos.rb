class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.7.2.tar.bz2"
  sha256 "2166e65be6d612317115bfec07827c11b403c3f303e0a7420a2106bc999d7707"

  bottle do
    cellar :any
    sha256 "8347358e36c773c315f742972786ac7a6e13f5998f799dd8fad3afec22ba5fcf" => :mojave
    sha256 "3f074801c641178e222dfa871463e1891419545e07c36bcedff0c00de8dc8c2a" => :high_sierra
    sha256 "efbe29b37717a44f1e1d625f338787dc945a5f8973c9b67d794cf25ae739a97c" => :sierra
  end

  depends_on "swig" => :build
  depends_on "python"

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python3-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-python",
                          "PYTHON=#{Formula["python"].opt_bin}/python3"
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
