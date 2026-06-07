{pkgs, ...}: {
  environment.systemPackages = with pkgs;[
    (dotnetCorePackages.combinePackages [
      dotnet-runtime_6
      dotnet-sdk_6
      dotnet-sdk_8
      dotnet-sdk_9
      dotnet-sdk_10
      dotnet-sdk_11
    ])
  ];
}