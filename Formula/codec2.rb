class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://hobbes1069.fedorapeople.org/freetel/codec2/codec2-0.8.1.tar.xz"
  sha256 "a07cdaacf59c3f7dbb1c63b769d443af486c434b3bd031fb4edd568ce3e613d6"

  bottle do
    cellar :any
    sha256 "92031b75a027390385864b1c2a4bde522da712162b7c6f8187a1b2adf74f8504" => :mojave
    sha256 "37a6ae2407ae97ae632078020e89163e9b58d3613207bcf534401f6660128108" => :high_sierra
    sha256 "d90f5373ac39385b8fffee0605afe2e27c195f44ef211f98d7b5d89c7200508d" => :sierra
    sha256 "896b96db4b2d4349ca56dc0e4daaf2bebfc28908197c013aefe89d86fe57317c" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build_osx" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # 8 bytes of raw audio data (silence).
    (testpath/"test.raw").write([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack("C*"))
    system "#{bin}/c2enc", "2400", "test.raw", "test.c2"
  end
end
