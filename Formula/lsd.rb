class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.15.1.tar.gz"
  sha256 "849ad168171737ef1ca74b762b3d9fb885c936cb9a753eca07426886478ad2de"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0b8a591c3f298ad1ca6c827e8b556aec7d763d5af4d2ea4b0301f2f89ba3f96" => :mojave
    sha256 "c508d0f378344fa96d2623103a181b91296e9237c52d2b80bc3906c17e32a72f" => :high_sierra
    sha256 "adcbf3b22c7804550f386545b4e5cac22e6bcba5e80c36e45dc3e03f93ec0dc7" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
