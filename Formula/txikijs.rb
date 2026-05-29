class Txikijs < Formula
  desc "Tiny JavaScript runtime"
  homepage "https://txikijs.org"
  # pull from git tag to get submodules
  url "https://github.com/saghul/txiki.js.git",
    tag:      "v26.5.0",
    revision: "9d7b4dbdf0cd653eab51a77144a2db77c5abcd1e"
  license "MIT"
  head "https://github.com/saghul/txiki.js.git", branch: "master"

  bottle do
    root_url "https://github.com/bangseongbeom/homebrew-tap/releases/download/txikijs-26.5.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "16ed70e2e10c0526ff7aa84faa87151a9f150464c9c5773a61021dfa533b64dc"
    sha256 cellar: :any_skip_relocation, sequoia:      "4a393275a13f7b80d5f591419ce7b5956b5d1b7d38a612aa99953872d189ccc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "09c8e2985b3ddf19d1dd665b031b2d1da18a46118c2f3e2517f8e2ebc993284f"
  end

  depends_on "cmake" => :build

  # txiki.js builds WAMR with SIMD support, which requires SIMDe via FetchContent
  resource "simde" do
    # Follow the SIMDe version in WAMR:
    # https://github.com/bytecodealliance/wasm-micro-runtime/blob/main/core/iwasm/libraries/simde/simde.cmake
    url "https://github.com/simd-everywhere/simde/archive/refs/tags/v0.8.2.tar.gz"
    sha256 "ed2a3268658f2f2a9b5367628a85ccd4cf9516460ed8604eed369653d49b25fb"
  end

  def install
    resource("simde").stage buildpath/"simde"
    system "cmake", "-S", ".", "-B", "build", "-DFETCHCONTENT_SOURCE_DIR_SIMDE=#{buildpath}/simde", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/tjs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tjs --version")
    assert_equal "hello", shell_output("#{bin}/tjs eval \"console.log('hello')\"").strip
  end
end
