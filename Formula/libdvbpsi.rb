class Libdvbpsi < Formula
  desc "Library to decode/generate MPEG TS and DVB PSI tables"
  homepage "https://www.videolan.org/developers/libdvbpsi.html"
  url "https://download.videolan.org/pub/libdvbpsi/1.3.2/libdvbpsi-1.3.2.tar.bz2"
  sha256 "ac4e39f2b9b1e15706ad261fa175a9430344d650a940be9aaf502d4cb683c5fe"

  bottle do
    cellar :any
    sha256 "58798e08191e81dad4757bd9a78cae7d9729eef19fdd58dcdecdcc1767a85c15" => :mojave
    sha256 "cf87681a1db342d27db787787363c0628e4af6b8e70cedd3a740f50e71a84a2a" => :high_sierra
    sha256 "1cf54943acbf49fac6505cb6d03ee80587192b9b627fe6727a3041eff5957a9f" => :sierra
    sha256 "619b9fd96ed520287fef752afdd48d7127cd8b88ce94fa0a6f4bda6e7726a4fe" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make", "install"
  end
end
