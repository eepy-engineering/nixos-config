{
  services = {
    calibre-web = {
      enable = true;
      listen = {
        ip = "0.0.0.0";
        port = 8448;
      };
      options = {
        enableBookUploading = true;
      };
    };
    # calibre-server = {
    #   enable = true;
    #   port = 8448;
    # };
  };
}
