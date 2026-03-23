class Txikijs < Formula
  desc "Tiny JavaScript runtime"
  homepage "https://txikijs.org"
  # pull from git tag to get submodules
  url "https://github.com/saghul/txiki.js.git",
    tag:      "v26.3.1",
    revision: "3cd6b4802551a5eca80e08633354ddcae2efd2bd"
  license "MIT"
  head "https://github.com/saghul/txiki.js.git", branch: "master"

  bottle do
    root_url "https://github.com/bangseongbeom/homebrew-txikijs/releases/download/txikijs-26.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f2b3c9060b41b6e6bc01b7863c978ae90a24bb3b36dd2a3820b03609525e8496"
    sha256 cellar: :any_skip_relocation, sequoia:      "e4d6d5b3776b2f4fd5fd6b6b864d36d3d1943a0390a2461fcc0578dd6eaaa637"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa815e7bb283bba6d12a33e707bdc387cd858c8590a831944f88ba6cc79fd15e"
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
