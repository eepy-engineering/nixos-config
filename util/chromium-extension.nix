browserVersion: {
  id,
  sha256,
  version,
}: {
  inherit id;
  crxPath = builtins.fetchurl {
    url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
    name = "${id}.crx";
    inherit sha256;
  };
  inherit version;
}
