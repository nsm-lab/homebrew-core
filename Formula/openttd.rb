class Openttd < Formula
  desc "Simulation game based upon Transport Tycoon Deluxe"
  homepage "https://www.openttd.org/"
  url "https://proxy.binaries.openttd.org/openttd-releases/1.9.1/openttd-1.9.1-source.tar.xz"
  sha256 "ff8158c1ddffebdb807fea8057c038fce1171e544fe11523e2ea70febe3711e5"
  head "https://github.com/OpenTTD/OpenTTD.git"

  bottle do
    cellar :any
    sha256 "3333b79a236fb29e00886d4252d1b9edc123b2c7a1b396c98d7f2c9496344100" => :mojave
    sha256 "b6b16c0022817e457621ba6e34fd1a4bf812c2056cd8129b0a2f63677e652e9e" => :high_sierra
    sha256 "98806975da80d6af83818e60c5dbcd0d62f2b9ac3ad741cd8af79f53c04d298c" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lzo"
  depends_on "xz"

  resource "opengfx" do
    url "https://binaries.openttd.org/extra/opengfx/0.5.5/opengfx-0.5.5-all.zip"
    sha256 "c648d56c41641f04e48873d83f13f089135909cc55342a91ed27c5c1683f0dfe"
  end

  resource "opensfx" do
    url "https://binaries.openttd.org/extra/opensfx/0.2.3/opensfx-0.2.3-all.zip"
    sha256 "6831b651b3dc8b494026f7277989a1d757961b67c17b75d3c2e097451f75af02"
  end

  resource "openmsx" do
    url "https://binaries.openttd.org/extra/openmsx/0.3.1/openmsx-0.3.1-all.zip"
    sha256 "92e293ae89f13ad679f43185e83fb81fb8cad47fe63f4af3d3d9f955130460f5"
  end

  def install
    system "./configure", "--prefix-dir=#{prefix}"
    system "make", "bundle"

    (buildpath/"bundle/OpenTTD.app/Contents/Resources/data/opengfx").install resource("opengfx")
    (buildpath/"bundle/OpenTTD.app/Contents/Resources/data/opensfx").install resource("opensfx")
    (buildpath/"bundle/OpenTTD.app/Contents/Resources/gm/openmsx").install resource("openmsx")

    prefix.install "bundle/OpenTTD.app"
    bin.write_exec_script "#{prefix}/OpenTTD.app/Contents/MacOS/openttd"
  end

  def caveats
    <<~EOS
      If you have access to the sound and graphics files from the original
      Transport Tycoon Deluxe, you can install them by following the
      instructions in section 4.1 of #{prefix}/readme.txt
    EOS
  end

  test do
    assert_match /OpenTTD #{version}\n/, shell_output("#{bin}/openttd -h")
  end
end
