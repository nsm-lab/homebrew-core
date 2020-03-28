class Cloc < Formula
  desc "Statistics utility to count lines of code"
  homepage "https://github.com/AlDanial/cloc/"
  url "https://github.com/AlDanial/cloc/archive/1.82.tar.gz"
  sha256 "7ab390f3a4888d9b78df420bff586326b53e3f7fc0e0c9ff9b160d076ca85a17"
  head "https://github.com/AlDanial/cloc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "661f3c3b8eb7e0a348e36b5b1b7aebf2b579eec5ae078e7f2d2c64ab302a3644" => :mojave
    sha256 "15a38a7a5172213f2c1577a0aef34260203d5e0c25d38c6a4a2252990a9c9414" => :high_sierra
    sha256 "7e7622a28e8b32af41a292174a2f1ac8aef6e7f6a4735fefa7a3c83f7a11dd65" => :sierra
  end

  resource "Regexp::Common" do
    url "https://cpan.metacpan.org/authors/id/A/AB/ABIGAIL/Regexp-Common-2017060201.tar.gz"
    sha256 "ee07853aee06f310e040b6bf1a0199a18d81896d3219b9b35c9630d0eb69089b"
  end

  resource "Algorithm::Diff" do
    url "https://cpan.metacpan.org/authors/id/T/TY/TYEMQ/Algorithm-Diff-1.1903.tar.gz"
    sha256 "30e84ac4b31d40b66293f7b1221331c5a50561a39d580d85004d9c1fff991751"
  end

  resource "Parallel::ForkManager" do
    url "https://cpan.metacpan.org/authors/id/Y/YA/YANICK/Parallel-ForkManager-1.20.tar.gz"
    sha256 "7cc4c1c3b0e676b61ffa90f82f4128e8057327449ca86a9beb2f39217023f289"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    # These are shipped as standard with OS X/macOS' default Perl, but
    # because upstream has chosen to use "#!/usr/bin/env perl" cloc will
    # use whichever Perl is in the PATH, which isn't guaranteed to include
    # these modules. Vendor them to be safe.
    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "make", "-C", "Unix", "prefix=#{libexec}", "install"
    bin.install libexec/"bin/cloc"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
    man1.install libexec/"share/man/man1/cloc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    assert_match "1,C,0,0,4", shell_output("#{bin}/cloc --csv .")
  end
end
