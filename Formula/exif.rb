class Exif < Formula
  desc "Read, write, modify, and display EXIF data on the command-line"
  homepage "https://libexif.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libexif/exif/0.6.21/exif-0.6.21.tar.gz"
  sha256 "1e2e40e5d919edfb23717308eb5aeb5a11337741e6455c049852128a42288e6d"

  bottle do
    cellar :any
    sha256 "f53bbbb67c2ed09c34e3afeedaf464675c0f9b5de5aa449422d23fc3c426b072" => :mojave
    sha256 "73abe70edbf8eaac5773627b225afe24461340c163849356ca8a730ac89f0f30" => :high_sierra
    sha256 "ae8645e99466b553e7198556a2d331759c9f173956dc0c10f584903030c78876" => :sierra
    sha256 "607827dc887cae86a2bedc7892e4d061990cb04814fb0ac2fd5d0cd1fdefcb30" => :el_capitan
    sha256 "ebf412bb43ad3695f01f8ed1e5851e7c02218589fc7cbb175c9a3f1914894e37" => :yosemite
    sha256 "e24a0bdfee07a46a49620c29726748e73a4eca0937c59c1f5efeeb51ea9f6971" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libexif"
  depends_on "popt"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-nls
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "The data supplied does not seem to contain EXIF data.",
                 shell_output("#{bin}/exif #{test_image} 2>&1", 1)
  end
end
