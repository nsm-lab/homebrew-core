class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/wavebitscientific/datetime-fortran"
  url "https://github.com/wavebitscientific/datetime-fortran/releases/download/v1.6.1/datetime-fortran-1.6.1.tar.gz"
  sha256 "a503319209c6b9abe2fd0dc46f3b0d096154ac6edad9a106270f82aef6d248c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "160cac6100d26f5e09387daac49d16c40aedd38a44dc5aa0da950a62fc4f601b" => :mojave
    sha256 "2b3663b87374f2aff2bbe1ddc6436a2e387cb0f158149fcc11f46b73aa530e89" => :high_sierra
    sha256 "16073e773f18e30155af5805975b085fbd9c715cf0dcfe006cd1091de97c2cc5" => :sierra
  end

  head do
    url "https://github.com/wavebitscientific/datetime-fortran.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "pkg-config" => :build
  end

  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
    (pkgshare/"test").install "src/tests/datetime_tests.f90"
  end

  test do
    system "gfortran", "-o", "test", "-I#{include}", "-L#{lib}", "-ldatetime",
                       pkgshare/"test/datetime_tests.f90"
    system "./test"
  end
end
