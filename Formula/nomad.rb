class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.9.3.tar.gz"
  sha256 "65ae3d7c7c88f9a344f88c2444356662eaa16683d0033bf9fbff691633f4e6fe"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a963e2ee68ed698964f5202e8eaab4f16df84ab873fcaf7088b4c80ae0d4ad34" => :mojave
    sha256 "26a0421bc6becf42a5aab763b38ed24a6cff40e47b1d05adc1e7240e2a8e6fe0" => :high_sierra
    sha256 "306a1bb527389fcdf094968fa5ba85ddec00886e428ef7a128f98702835a6a94" => :sierra
  end

  depends_on "go@1.11" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/hashicorp/nomad"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-tags", "ui", "-o", bin/"nomad"
      prefix.install_metafiles
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/nomad", "agent", "-dev"
      end
      sleep 10
      ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
      system "#{bin}/nomad", "node-status"
    ensure
      Process.kill("TERM", pid)
    end
  end
end
