class Tile38 < Formula
  desc "In-memory geolocation data store, spatial index, and realtime geofence"
  homepage "https://tile38.com/"
  url "https://github.com/tidwall/tile38/archive/1.17.2.tar.gz"
  sha256 "b8fab1adbbe3be98798ee81d379bc1add528512f5233c32760c29f0874ba255c"
  head "https://github.com/tidwall/tile38.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab557360308a63d2b49b1b8df23a7f3708ea735831fde988ec41b6b22a5c0131" => :mojave
    sha256 "17c82d566892d26210b7d940cce0832465b3c5162c6cbf356a65c7867080d9c2" => :high_sierra
    sha256 "e0022ade850b378f430ef718cdc682bed3441d2641d19f46d193597478241f2d" => :sierra
  end

  depends_on "go" => :build

  def datadir
    var/"tile38/data"
  end

  def install
    ENV["GOPATH"] = buildpath
    system "make"

    bin.install "tile38-cli", "tile38-server"
  end

  def post_install
    # Make sure the data directory exists
    datadir.mkpath
  end

  def caveats; <<~EOS
    To connect: tile38-cli
  EOS
  end

  plist_options :manual => "tile38-server -d #{HOMEBREW_PREFIX}/var/tile38/data"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/tile38-server</string>
          <string>-d</string>
          <string>#{datadir}</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/tile38.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/tile38.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/tile38-server", "-q"
      end
      sleep 2
      json_output = shell_output("#{bin}/tile38-cli server")
      tile38_server = JSON.parse(json_output)
      assert_equal tile38_server["ok"], true
    ensure
      Process.kill("HUP", pid)
    end
  end
end
