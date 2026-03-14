class Ghx < Formula
  desc "Run any repository from source without worrying about the runtime"
  homepage "https://github.com/uraura/ghx"
  url "https://github.com/uraura/ghx/archive/refs/tags/v0.1.0.tar.gz"
  sha256 ""
  license "MIT"

  depends_on "ghq"

  def install
    bin.install "ghx"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/ghx --help")
  end
end
