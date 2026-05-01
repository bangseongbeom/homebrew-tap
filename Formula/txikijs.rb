class Txikijs < Formula
  desc "Tiny JavaScript runtime"
  homepage "https://txikijs.org"
  # pull from git tag to get submodules
  url "https://github.com/saghul/txiki.js.git",
    tag:      "v26.4.0",
    revision: "e914852b2d0fe186c8f5391b37e04057f6307ff7"
  license "MIT"
  head "https://github.com/saghul/txiki.js.git", branch: "master"

  bottle do
    root_url "https://github.com/bangseongbeom/homebrew-tap/releases/download/txikijs-26.4.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "b7b9586ac809245fc3b41f3221b04675bc8af9f26d869991a63c1ad38caacc69"
    sha256 cellar: :any_skip_relocation, sequoia:      "5a7af7e6d0020288a6f1ab8ea0e52478cc924e84067cb9af47b18d491922c69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2b91587621ee43d6baf979c884eff78460b4895735b3d954dfe717429abeade2"
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
