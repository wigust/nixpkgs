with import (builtins.fetchTarball {
  url =
    "https://github.com/nixos/nixpkgs/archive/cc3b6aa322f307580d48c975a3b86b4462b645d8.tar.gz";
}) {
  config = {
    allowBroken = true;
    allowUnfree = true;
    allowUnsupportedSystem = true;
    firefox.icedtea = true;
    permittedInsecurePackages = [
      "autotrace-0.31.1"
      "batik-1.6"
      "firefox-52.9.0esr"
      "firefox-esr-unwrapped-52.9.0esr"
    ];
  };
};

let
  cacert = (import <nixpkgs> {
    overlays = [
      (import (builtins.fetchGit {
        url = "https://gitlab.intr/_ci/nixpkgs";
        ref = "master";
      }))
    ];
  }).withMajordomoCacert.cacert;

  nixpkgsJdk7 = (import (builtins.fetchTarball {
    url =
      "https://github.com/nixos/nixpkgs/archive/bdb06c093670e41c004b4d48cce83c4f655e6d1d.tar.gz";
  }) { });

  mj-jdk7 = nixpkgsJdk7.jdk7.override ({ inherit cacert; });

  mj-adoptopenjdk-icedtea-web7 =
    nixpkgsJdk7.icedtea7_web.override { jdk = mj-jdk7; };

  mj-wrapFirefox = wrapFirefox.override {
    adoptopenjdk-icedtea-web = mj-adoptopenjdk-icedtea-web7;
  };

  mj-firefox = mj-wrapFirefox firefox-esr-52-unwrapped { };

in (stdenv.mkDerivation {
  name = "firefox-esr-52";
  builder = writeScript "builder.sh" (''
    source $stdenv/setup
    mkdir -p $out/bin
    cat > $out/bin/javaws <<'EOF'
    #!${bash}/bin/bash -e
    exec -a javaws ${mj-adoptopenjdk-icedtea-web7}/bin/javaws -Xnofork -Xignoreheaders  -allowredirect -nosecurity "$@"
    EOF
    chmod 555 $out/bin/javaws

    cat > $out/bin/firefox-esr-52 <<'EOF'
    #!${bash}/bin/bash -e
    exec -a firefox-esr-52 ${mj-firefox}/bin/firefox "$@"
    EOF
    chmod 555 $out/bin/firefox-esr-52
  '');
})
