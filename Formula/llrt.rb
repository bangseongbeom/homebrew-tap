class Llrt < Formula
  desc "Lightweight JavaScript runtime"
  homepage "https://github.com/awslabs/llrt"
  # pull from git tag to get submodules
  url "https://github.com/awslabs/llrt.git",
    tag:      "v0.10.0-beta",
    revision: "b7ccc1487be185ac65fa4355e022bf9eea4df076"
  license "Apache-2.0"
  head "https://github.com/awslabs/llrt.git", branch: "main"

  livecheck do
    url :stable
    strategy :git
  end

  bottle do
    root_url "https://github.com/bangseongbeom/homebrew-tap/releases/download/llrt-0.10.0-beta"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "089fcf1ad8e80cb447d589bdce77bd64dceeaaee1afb5a69409bc6eac720e515"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ec741837a91833c18f1bf7a7304611ed9fc53fa0f9ca8aaa79c153566f654b69"
  end

  depends_on "cmake" => :build
  depends_on "corepack" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "rustup" => :build
  depends_on "zig" => :build
  depends_on "zstd" => :build

  uses_from_macos "zip" => :build

  def install
    system "git", "submodule", "update", "--init", "--checkout"

    system "corepack", "enable", "--install-directory", buildpath
    system "yarn"

    ENV.deparallelize
    system "make", "stdlib"
    system "make", "libs"

    system "make", "release"

    bin.install Dir["target/*/release/llrt"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llrt --version")
    assert_equal "hello", shell_output("#{bin}/llrt -e \"console.log('hello')\"").strip
  end
end
