class Txikijs < Formula
  desc "Tiny JavaScript runtime"
  homepage "https://txikijs.org"
  # pull from git tag to get submodules
  url "https://github.com/saghul/txiki.js.git",
    tag:      "v26.3.0",
    revision: "9419f742e0c0470af500a4513ad4f529937d4fe7"
  license "MIT"
  head "https://github.com/saghul/txiki.js.git", branch: "master"

  depends_on "cmake" => :build

  # txiki.js builds WAMR with SIMD support, which requires SIMDe via FetchContent
  resource "simde" do
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
