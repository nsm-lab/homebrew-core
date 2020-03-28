class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.7.0.tar.gz"
  sha256 "c9a4c0bd88123064d483ab46ecee777f14d933359e23bff6fb4f4dbd28b4cd41"
  head "https://github.com/capnproto/capnproto.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "86b0a4f0bbc70a1bc04cbdd1b2312974e2acd56e606a2865e1dfbc48f07c2d1e" => :mojave
    sha256 "a4720c5dc1b0866536b4649a87e16149d29cdaa730ced45acd7e557918dc5285" => :high_sierra
    sha256 "56c4c541de5388071f53d582a12b7d0672c476ecf15130122d527bde2af4f358" => :sierra
    sha256 "c828367f66d7b83289de33b8b3d47cc32dcc1b8da555469bdf886f2a7febdf2b" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write Utils.popen_read("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end
