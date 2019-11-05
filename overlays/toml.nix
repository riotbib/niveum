(self: super: {
  writeTOML = object: super.runCommand "writeTOML" {} ''
    echo '${builtins.toJSON object}' | ${super.remarshal}/bin/json2toml > $out
  '';
  toTOML = object: builtins.readFile (self.writeTOML object);
})
