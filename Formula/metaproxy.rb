class Metaproxy < Formula
  desc "Z39.50 proxy and router utilizing Yaz toolkit"
  homepage "https://www.indexdata.com/metaproxy"
  url "http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.15.0.tar.gz"
  sha256 "b43a9e4dd2c231442ea07af7a05e929cd6cae2921826f66d201397b838aa8aac"
  revision 3

  bottle do
    cellar :any
    sha256 "457f46ba4defa7420c038454364918f9534748c19cc580336f4cc92c18950408" => :mojave
    sha256 "a9c9e883e70f0dc8173d6f2c43218de0178024fa080f114495c136e7545db9a1" => :high_sierra
    sha256 "89c12962098cbc8fac874979f849f927b6dd8eca2df6f183062a37ba2501264f" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yazpp"

  # fix build for boost 1.69
  patch do
    url "https://github.com/indexdata/metaproxy/commit/186513e6205c6b0216e727907aa9e8d7b162f070.patch?full_index=1"
    sha256 "69579e45d27de8243f7ea3d7d3d23ef954ba7949995f08c07f7f88e81601fb39"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  # Test by making metaproxy test a trivial configuration file (etc/config0.xml).
  test do
    (testpath/"test-config.xml").write <<~EOS
      <?xml version="1.0"?>
      <metaproxy xmlns="http://indexdata.com/metaproxy" version="1.0">
        <start route="start"/>
        <filters>
          <filter id="frontend" type="frontend_net">
            <port max_recv_bytes="1000000">@:9070</port>
            <message>FN</message>
            <stat-req>/fn_stat</stat-req>
          </filter>
        </filters>
        <routes>
          <route id="start">
            <filter refid="frontend"/>
            <filter type="log"><category access="false" line="true" apdu="true" /></filter>
            <filter type="backend_test"/>
            <filter type="bounce"/>
          </route>
        </routes>
      </metaproxy>
    EOS

    system "#{bin}/metaproxy", "-t", "--config", "#{testpath}/test-config.xml"
  end
end
