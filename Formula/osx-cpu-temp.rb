class OsxCpuTemp < Formula
  desc "Outputs current CPU temperature for OSX"
  homepage "https://github.com/lavoiesl/osx-cpu-temp"
  url "https://github.com/lavoiesl/osx-cpu-temp/archive/1.1.0.tar.gz"
  sha256 "94b90ce9a1c7a428855453408708a5557bfdb76fa45eef2b8ded4686a1558363"

  bottle do
    cellar :any_skip_relocation
    sha256 "c0301d2c47c23bc8ed0042fbaf447e82ca8dbbf10b1939d9a4f684961a24d0d2" => :mojave
    sha256 "2255aa28242ce07a62fc0eabaf146592fb70745e641cfc775a21f99841cec625" => :high_sierra
    sha256 "d68a47b126eaee8f75d281785322877055187f89540eb2744b9cd4da15ca6a69" => :sierra
  end

  def install
    system "make"
    bin.install "osx-cpu-temp"
  end

  test do
    assert_match "°C", shell_output("#{bin}/osx-cpu-temp -C")
  end
end
