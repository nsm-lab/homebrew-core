class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.5/+download/juju-core_2.6.5.tar.gz"
  sha256 "2222b5cfec023d7f6dca1f3f4dd4aa78e8d626d8debbb1f721b723f5ed584482"

  bottle do
    cellar :any_skip_relocation
    sha256 "e15b0f01ed40d97e8e7b97e7bdbed94ffac93fce02b2bd18fe8a9f8b3b950f6d" => :mojave
    sha256 "8116144194e98eb743f021c179c79950d4a6d588c601e5a859dff6978fcfbca4" => :high_sierra
    sha256 "15effd09d7bb1e72ed86c8408676187fee9d1b6549d95a5b59163381a1784fd4" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
