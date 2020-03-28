class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https://www.minetest.net/"

  stable do
    url "https://github.com/minetest/minetest/archive/5.0.1.tar.gz"
    sha256 "aa771cf178ad1b436d5723e5d6dd24e42b5d56f1cfe9c930f6426b7f24bb1635"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game/archive/5.0.1.tar.gz"
      sha256 "965d2cf3ac8c822bc9e60fb8f508182fb2f24dde46f46b000caf225ebe2ec519"
    end
  end

  bottle do
    sha256 "21668f152c915c3376690da7c99f4efddaf8dfb138c550322b40789d4a50173b" => :mojave
    sha256 "4d05b170855c4215a39ba37e520f4f338de88e6bef724ac7201683272f4c7fdf" => :high_sierra
    sha256 "5122d65cef9f5f63b3511f627e25408cadf8f0158c119262413a9e8b8666ddc5" => :sierra
  end

  head do
    url "https://github.com/minetest/minetest.git"

    resource "minetest_game" do
      url "https://github.com/minetest/minetest_game.git", :branch => "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "irrlicht"
  depends_on "jpeg"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"

  def install
    (buildpath/"games/minetest_game").install resource("minetest_game")

    args = std_cmake_args - %w[-DCMAKE_BUILD_TYPE=None]
    args << "-DCMAKE_BUILD_TYPE=Release" << "-DBUILD_CLIENT=1" << "-DBUILD_SERVER=0"
    args << "-DENABLE_FREETYPE=1" << "-DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'"
    args << "-DENABLE_GETTEXT=1" << "-DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}"

    system "cmake", ".", *args
    system "make", "package"
    system "unzip", "minetest-*-osx.zip"
    prefix.install "minetest.app"
  end

  def caveats
    <<~EOS
      Put additional subgames and mods into "games" and "mods" folders under
      "~/Library/Application Support/minetest/", respectively (you may have
      to create those folders first).

      If you would like to start the Minetest server from a terminal, run
      "/Applications/minetest.app/Contents/MacOS/minetest --server".
    EOS
  end
end
