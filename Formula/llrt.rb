class Llrt < Formula
  desc "Lightweight JavaScript runtime"
  homepage "https://github.com/awslabs/llrt"
  # pull from git tag to get submodules
  url "https://github.com/awslabs/llrt.git",
    tag:      "v0.9.0-beta",
    revision: "0a10758f31eec3e5421a6b8ff1f459df1f4354c4"
  license "Apache-2.0"
  head "https://github.com/awslabs/llrt.git", branch: "main"

  livecheck do
    url :stable
    strategy :git
  end

  bottle do
    root_url "https://github.com/bangseongbeom/homebrew-tap/releases/download/llrt-0.9.0-beta"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "d0bbcd7248fb6f5b8ae59ba0b3356c2880268ad87d7a702044516c000cfef3e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3dd710820568017b57e75c5282da0a8bff898b8f9604d9686defd91b6d241f7f"
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
