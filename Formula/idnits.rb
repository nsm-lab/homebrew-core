class Idnits < Formula
  desc "Looks for problems in internet draft formatting"
  homepage "https://tools.ietf.org/tools/idnits/"
  url "https://tools.ietf.org/tools/idnits/idnits-2.16.02.tgz"
  sha256 "e9a501fc1f3a4584dda854067398eaebba29f128fb09f80048a760e950c35c49"

  bottle :unneeded

  resource "test" do
    url "https://tools.ietf.org/id/draft-ietf-tcpm-undeployed-03.txt"
    sha256 "34e72c2c089409dc1935e18f75351025af3cfc253dee50db042d188b46733550"
  end

  def install
    bin.install "idnits"
  end

  test do
    resource("test").stage do
      system "#{bin}/idnits", "draft-ietf-tcpm-undeployed-03.txt"
    end
  end
end
