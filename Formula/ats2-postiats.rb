class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.12/ATS2-Postiats-0.3.12.tgz"
  sha256 "63eb02b225a11752745e8f08691140ed764288ab4ceda3710670cde24835b0d8"

  bottle do
    cellar :any
    sha256 "71301764b2f0f5e8e9a3dfadb3a232d758a48cc3f42a0c3c6e8588319d8a528c" => :mojave
    sha256 "009876aeeda5ff2a4294ce33b9f214a0e5fdf7e46f01bc8826702f84220bdad1" => :high_sierra
    sha256 "03fb2632e129c51dcf3da35df4094e5a699d61676f49428478fdb1899d76c006" => :sierra
  end

  depends_on "gmp"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "install"
  end

  test do
    (testpath/"hello.dats").write <<~EOS
      val _ = print ("Hello, world!\n")
      implement main0 () = ()
    EOS
    system "#{bin}/patscc", "hello.dats", "-o", "hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
