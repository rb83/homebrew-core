class Nsync < Formula
  desc "C library that exports various synchronization primitives"
  homepage "https://github.com/google/nsync"
  url "https://github.com/google/nsync/archive/refs/tags/1.27.0.tar.gz"
  sha256 "e8e552a358f4a28e844207a7c5cb51767e4aeb0b29e22d23ac2a09924130f761"
  license "Apache-2.0"

  depends_on "cmake" => :build

  # upstream patch PR, https://github.com/google/nsync/pull/17
  patch do
    url "https://github.com/google/nsync/commit/25328714a3e645e353c1e9b29b4ef69aa8ac75d2.patch?full_index=1"
    sha256 "a8ff227f1edaa18a4d0f6e29261e828426acd66fb6937f1a6dd021436cdc83f7"
  end

  def install
    system "cmake", "-S", ".", "-B", "_build", "-DNSYNC_ENABLE_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nsync.h>
      #include <stdio.h>

      int main() {
        nsync_mu mu;
        nsync_mu_init(&mu);
        nsync_mu_lock(&mu);
        nsync_mu_unlock(&mu);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lnsync", "-o", "test"
    system "./test"
  end
end
