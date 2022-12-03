{lib, stdenv, wayland, wayland-protocols, ... } :

stdenv.mkDerivation rec {
  pname = "lswt";
  version = "1.0.4";

  src = fetchTarball {
    url = "https://git.sr.ht/~leon_plickat/${pname}/archive/v${version}.tar.gz";
    sha256 = "0kb0167bkmwrz6441arinc00ygmaz5wgsaj7kjrhgs3rqpp1mg1s";
  };

  buildInputs = [ wayland wayland-protocols ];
}
