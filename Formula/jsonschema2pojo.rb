class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "http://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-1.0.1/jsonschema2pojo-1.0.1.tar.gz"
  sha256 "2184c4fd3ed3ba4674297765ea55c750346f81838ee9cde9d8d36be023465c0a"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install "jsonschema2pojo-#{version}-javadoc.jar", "lib"
    bin.write_jar_script libexec/"lib/jsonschema2pojo-cli-#{version}.jar", "jsonschema2pojo"
  end

  test do
    (testpath/"src/jsonschema.json").write <<~EOS
      {
        "type":"object",
        "properties": {
          "foo": {
            "type": "string"
          },
          "bar": {
            "type": "integer"
          },
          "baz": {
            "type": "boolean"
          }
        }
      }
    EOS
    system bin/"jsonschema2pojo", "-s", "src", "-t", testpath
    assert_predicate testpath/"Jsonschema.java", :exist?, "Failed to generate Jsonschema.java"
  end
end
