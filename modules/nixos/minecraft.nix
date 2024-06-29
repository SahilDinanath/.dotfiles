{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    minecraft-server.enable = lib.mkEnableOption "Enable Minecraft server";
  };

  config = lib.mkIf config.minecraft-server.enable {
    services.minecraft-server = {
      enable = true;
      declarative = true;
      eula = true;
      openFirewall = true;
      whitelist = {
        vertigo = "e751d7b9-c38a-4fd5-875c-1e142fb660c9";
      };

      serverProperties = {
        server-port = 43000;
        difficulty = 3;
        gamemode = 1;
        max-players = 5;
        motd = "NixOS Minecraft server!";
        white-list = true;
        enable-rcon = true;
        "rcon.password" = "TheGents";
      };

    };
  };
}
