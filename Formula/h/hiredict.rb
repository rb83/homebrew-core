class Hiredict < Formula
  desc "C client library for Redict"
  homepage "https://codeberg.org/redict/hiredict"
  url "https://codeberg.org/redict/hiredict/archive/1.3.1.tar.gz"
  sha256 "377eb938930825a07b5b48c6dd171c59f439cd8c87c33f9c8dff6da3fc11ff5a"
  license all_of: ["BSD-3-Clause", "LGPL-3.0-or-later"]
  head "https://codeberg.org/redict/hiredict.git", branch: "main"

  depends_on "openssl@3"

  def install
    system "make", "install", "PREFIX=#{prefix}", "USE_SSL=1"
    pkgshare.install "examples"

    # remove versioned dynamic library links
    rm Dir["#{lib}/*.dylib.*"]
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, pkgshare/"examples/example.c", "-o", testpath/"test",
                   "-I#{include}/hiredict", "-L#{lib}", "-lhiredict"
    assert_predicate testpath/"test", :exist?
  end
end
