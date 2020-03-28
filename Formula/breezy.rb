class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org"
  url "https://files.pythonhosted.org/packages/f6/8a/f5aab26e6769907afda49a79e19dfa187a9f84797d9147ee6e35b52d97b9/breezy-3.0.0.tar.gz"
  sha256 "d5723a7a3fcaa827bf2731c20df5240d7063c7728b2db3a5d58bc90f6257f878"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a5168ff98a8a820806d15619f793189a3f61876879121a5cd7d4b2e1e723dd5" => :mojave
    sha256 "5f508532d94dcfb5346666b78a2762608294d51b5580ecf047dbdfb4f4c52243" => :high_sierra
    sha256 "ab4a0b94706bb8f761ba47f60603736364838306c2d108e1c332506d680ff18b" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "openssl"
  depends_on "python"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/f0/f8/7f406aac4c6919d5a4ce16509bbe059cd256e9ad94bae5ccac14094b7c51/Cython-0.29.1.tar.gz"
    sha256 "18ab7646985a97e02cee72e1ddba2e732d4931d4e1732494ff30c5aa084bfb97"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/2e/02/42ce6e45a206ccb044d8a3296646497e96b5263624e5862d21da947b9d59/dulwich-0.19.11.tar.gz"
    sha256 "afbe070f6899357e33f63f3f3696e601731fef66c64a489dea1bc9f539f4a725"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/a4/57/86681372e7a8d642718cadeef38ead1c24c4a1af21ae852642bf974e37c7/paramiko-2.4.2.tar.gz"
    sha256 "a8975a7df3560c9f1e2b43dc54ebd40fd00a7017392ca5445ce7df409f900fcb"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
