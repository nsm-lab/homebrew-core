class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-22.0.7.tar.gz"
  sha256 "04c090b55ec4a01778e7e1a5b7fdf54012548ca72737965b7aa8c4d7878c92bc"
  head "https://github.com/erlang/otp.git"

  bottle do
    cellar :any
    sha256 "1158d2c1839d793c63b776509a764681b160bd41cfc99913196a24ca113843eb" => :mojave
    sha256 "0649b93f990b227b27c8d0f8489a34a060bdd40e9a0cefbefd1f07163b559a6f" => :high_sierra
    sha256 "21bd49ab0d479272cd3b2d5b5de1299d741d4561470930ddaa462d17716dc283" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  resource "man" do
    url "https://www.erlang.org/download/otp_doc_man_22.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_man_22.0.tar.gz"
    sha256 "c3acdb3c7c69eaceb8bcd5a69f8a19ba8320d403c176a3b560f9240b943ab370"
  end

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_22.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_22.0.tar.gz"
    sha256 "64da88a0045501264105b4cc8023821810d23058404a3aadb8da1bc8fb5c13cb"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
      --enable-darwin-64bit
    ]

    args << "--enable-kernel-poll" if MacOS.version > :el_capitan
    args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?

    system "./configure", *args
    system "make"
    system "make", "install"

    (lib/"erlang").install resource("man").files("man")
    doc.install resource("html")
  end

  def caveats; <<~EOS
    Man pages can be found in:
      #{opt_lib}/erlang/man

    Access them with `erl -man`, or add this directory to MANPATH.
  EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
  end
end
