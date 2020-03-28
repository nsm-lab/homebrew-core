class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "http://www.sile-typesetter.org/"
  url "https://github.com/simoncozens/sile/releases/download/v0.9.5.1/sile-0.9.5.1.tar.bz2"
  sha256 "60cdcc4509971973feab352dfc1a86217cc1fdb12d56823f04d863afef92003a"
  revision 1

  head "https://github.com/simoncozens/sile.git"

  bottle do
    cellar :any
    sha256 "12de7ca23d0c7a5cb5a092038035c387dad903104aeea27e33695c331f468697" => :mojave
    sha256 "e9ab785e292c2cf41c4be79a36107bed3a8da920764799fd16c1c9933e503537" => :high_sierra
    sha256 "12583105738af88dbed8fafc2f00f4763035e073dc5f0e1b0b89a4c79b0a0c97" => :sierra
  end

  if build.head?
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "expat"
  depends_on "fontconfig"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "lua"
  depends_on "openssl"
  depends_on "zlib"

  resource "lpeg" do
    url "http://www.inf.puc-rio.br/~roberto/lpeg/lpeg-1.0.1.tar.gz"
    mirror "https://mirror.sobukus.de/files/grimoire/lua-forge/lpeg-1.0.1.tar.gz"
    sha256 "62d9f7a9ea3c1f215c77e0cadd8534c6ad9af0fb711c3f89188a8891c72f026b"
  end

  resource "lua-zlib" do
    url "https://github.com/brimworks/lua-zlib/archive/v1.2.tar.gz"
    sha256 "26b813ad39c94fc930b168c3418e2e746af3b2e80b92f94f306f6f954cc31e7d"
  end

  resource "luaexpat" do
    url "https://matthewwild.co.uk/projects/luaexpat/luaexpat-1.3.0.tar.gz"
    sha256 "d060397960d87b2c89cf490f330508b7def1a0677bdc120531c571609fc57dc3"
  end

  resource "luafilesystem" do
    url "https://github.com/keplerproject/luafilesystem/archive/v1_7_0_2.tar.gz"
    sha256 "23b4883aeb4fb90b2d0f338659f33a631f9df7a7e67c54115775a77d4ac3cc59"
  end

  resource "luasocket" do
    url "https://github.com/diegonehab/luasocket/archive/v3.0-rc1.tar.gz"
    sha256 "8b67d9b5b545e1b694753dab7bd6cdbc24c290f2b21ba1e14c77b32817ea1249"
  end

  resource "luasec" do
    url "https://github.com/brunoos/luasec/archive/luasec-0.7.tar.gz"
    sha256 "2176e95b1d2a72a3235ede5d2aa9838050feee55dade8fdbde4be7fdc66f3a31"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.3/?.lua;;#{luapath}/share/lua/5.3/lxp/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

    resources.each do |r|
      r.stage do
        if r.name == "lua-zlib"
          # https://github.com/brimworks/lua-zlib/commit/08d6251700965
          mv "lua-zlib-1.1-0.rockspec", "lua-zlib-1.2-0.rockspec"
          system "luarocks", "make", "#{r.name}-#{r.version}-0.rockspec", "--tree=#{luapath}", "ZLIB_DIR=/usr/local/opt/zlib"
        elsif r.name == "luaexpat"
          system "luarocks", "build", r.name, "--tree=#{luapath}", "EXPAT_DIR=/usr/local/opt/expat"
        elsif r.name == "luasec"
          system "luarocks", "build", r.name, "--tree=#{luapath}", "OPENSSL_DIR=/usr/local/opt/openssl"
        else
          system "luarocks", "build", r.name, "--tree=#{luapath}"
        end
      end
    end

    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-lua=#{prefix}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    (libexec/"bin").install bin/"sile"
    (bin/"sile").write <<~EOS
      #!/bin/bash
      export LUA_PATH="#{ENV["LUA_PATH"]}"
      export LUA_CPATH="#{ENV["LUA_CPATH"]}"
      "#{libexec}/bin/sile" "$@"
    EOS
  end

  test do
    assert_match "SILE #{version.to_s.match(/\d\.\d\.\d/)}", shell_output("#{bin}/sile --version")
  end
end
