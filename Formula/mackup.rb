class Mackup < Formula
  include Language::Python::Virtualenv

  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.24.tar.gz"
  sha256 "2da9bdd60e0be3724d58c6874b573fe8f4ef5438cb209201607f093a016b73d5"
  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75d05ae40d68151a05c113c7887280d343fee356e0cb3f76b546c92073203119" => :mojave
    sha256 "79ed8709ce02d8b3d94e139d21a4b6726e434d52df3f9142ea7e45bea47c42b0" => :high_sierra
    sha256 "5b7c88fc3fe73913350e5c4486f3e529ec0b1d6f9e782ded7bbe4d0868fd1b4a" => :sierra
  end

  depends_on "python"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
