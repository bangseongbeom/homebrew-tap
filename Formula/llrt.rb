class Llrt < Formula
  desc "Lightweight JavaScript runtime"
  homepage "https://github.com/awslabs/llrt"
  # pull from git tag to get submodules
  url "https://github.com/awslabs/llrt.git",
    tag:      "v0.8.1-beta",
    revision: "a3a1463732c7027645b2bc95b49b00b2027291bf"
  license "Apache-2.0"
  head "https://github.com/awslabs/llrt.git", branch: "main"

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
    # There is an issue where it outputs v0.8.0-beta even though it is v0.8.1-beta.
    # https://github.com/awslabs/llrt/issues/1446#issue-4067925791
    # assert_match version.to_s, shell_output("#{bin}/llrt --version")
    assert_equal "hello", shell_output("#{bin}/llrt -e \"console.log('hello')\"").strip
  end
end
