class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.15.0/logrotate-3.15.0.tar.xz"
  sha256 "313612c4776a305393454c874ef590d8acf84c9ffa648717731dfe902284ff8f"

  bottle do
    cellar :any
    sha256 "aa5d14ef7aacf37ef9348987cdb5367122d50c0c64b32f4dd809a66a194c2e60" => :mojave
    sha256 "d0c9c3ad9fe45fe8bda6dfc25cbf5e4b56d0c3489f578cdd09c65dfdd992d856" => :high_sierra
    sha256 "58b6fbae1676aa8fe9342b799eef31499ae1f111e7989c304465fda16ee650d0" => :sierra
  end

  depends_on "popt"

  # https://github.com/logrotate/logrotate/issues/241 "macOS timer functions"
  # Should be safe to remove on > 3.15.0 release
  patch do
    url "https://github.com/logrotate/logrotate/commit/0d805ce.patch?full_index=1"
    sha256 "a374fb6354c517da9a229373241db4802c549c05d7822462b905f0262a316be0"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-compress-command=/usr/bin/gzip",
                          "--with-uncompress-command=/usr/bin/gunzip",
                          "--with-state-file-path=#{var}/lib/logrotate.status"
    system "make", "install"

    inreplace "examples/logrotate.conf", "/etc/logrotate.d", "#{etc}/logrotate.d"
    etc.install "examples/logrotate.conf" => "logrotate.conf"
    (etc/"logrotate.d").mkpath
  end

  plist_options :manual => "logrotate"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/logrotate</string>
          <string>#{etc}/logrotate.conf</string>
        </array>
        <key>RunAtLoad</key>
        <false/>
        <key>StartCalendarInterval</key>
        <dict>
          <key>Hour</key>
          <integer>6</integer>
          <key>Minute</key>
          <integer>25</integer>
        </dict>
      </dict>
    </plist>
  EOS
  end

  test do
    (testpath/"test.log").write("testlograndomstring")
    (testpath/"testlogrotate.conf").write <<~EOS
      #{testpath}/test.log {
        size 1
        copytruncate
      }
    EOS
    system "#{sbin}/logrotate", "-s", "logstatus", "testlogrotate.conf"
    assert(File.size?("test.log").nil?, "File is not zero length!")
  end
end
