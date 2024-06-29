{
  lib,
  config,
  pkgs,
  ...
}:
let
  # check every 20 seconds if the server
  # need to be stopped
  frequency-check-players = "*-*-* *:*:0/20";
  # time in second before we could stop the server
  # this should let it time to spawn
  minimum-server-lifetime = 300;
  # minecraft port
  # used in a few places in the code
  # this is not the port that should be used publicly
  # don't need to open it on the firewall
  minecraft-port = 25564;

  # this is the port that will trigger the server start
  # and the one that should be used by players
  # you need to open it in the firewall
  public-port = 25565;
  # a rcon password used by the local systemd commands
  # to get information about the server such as the
  # player list
  # this will be stored plaintext in the store
  rcon-password = "TheGents";

  # a script used by hook-minecraft.service
  # to start minecraft and the timer regularly
  # polling for stopping it
  start-mc = pkgs.writeShellScriptBin "start-mc" ''
    systemctl start minecraft-server.service
    systemctl start stop-minecraft.timer
  '';

  # wait 60s for a TCP socket to be available
  # to wait in the proxifier
  # idea found in https://blog.developer.atlassian.com/docker-systemd-socket-activation/
  wait-tcp = pkgs.writeShellScriptBin "wait-tcp" ''
    for i in `seq 60`; do
      if ${pkgs.libressl.nc}/bin/nc -z 127.0.0.1 ${toString minecraft-port} > /dev/null ; then
        exit 0
      fi
      ${pkgs.busybox.out}/bin/sleep 1
    done
    exit 1
  '';

  # script returning true if the server has to be shutdown
  # for minecraft, uses rcon to get the player list
  # skips the checks if the service started less than minimum-server-lifetime
  no-player-connected = pkgs.writeShellScriptBin "no-player-connected" ''
    servicestartsec=$(date -d "$(systemctl show --property=ActiveEnterTimestamp minecraft-server.service | cut -d= -f2)" +%s)
    serviceelapsedsec=$(( $(date +%s) - servicestartsec))

    # exit if the server started less than 5 minutes ago
    if [ $serviceelapsedsec -lt ${toString minimum-server-lifetime} ]
    then
      echo "server is too young to be stopped"
      exit 1
    fi

    PLAYERS=`printf "list\n" | ${pkgs.rcon.out}/bin/rcon -m -H 127.0.0.1 -p 25575 -P ${rcon-password}`
    if echo "$PLAYERS" | grep "are 0 of a"
    then
      exit 0
    else
      exit 1
    fi
  '';
in
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
        higanbaka = "2e82c5bb-9e99-4f37-9f48-2027ff802377";
        vertigo = "e751d7b9-c38a-4fd5-875c-1e142fb660c9";
      };

      serverProperties = {
        server-port = public-port;
        difficulty = 3;
        gamemode = 1;
        max-players = 5;
        motd = "NixOS Minecraft server!";
        white-list = true;
        enable-rcon = true;
        "rcon.password" = rcon-password;
      };

    };
    # don't start Minecraft on startup
    systemd.services.minecraft-server = {
      wantedBy = pkgs.lib.mkForce [ ];
    };
    # this waits for incoming connection on public-port
    # and triggers listen-minecraft.service upon connection
    systemd.sockets.listen-minecraft = {
      enable = true;
      wantedBy = [ "sockets.target" ];
      requires = [ "network.target" ];
      listenStreams = [ "${toString public-port}" ];
    };
    # this is triggered by a connection on TCP port public-port
    # start hook-minecraft if not running yet and wait for it to return
    # then, proxify the TCP connection to the real Minecraft port on localhost
    systemd.services.listen-minecraft = {
      path = with pkgs; [ systemd ];
      enable = true;
      requires = [
        "hook-minecraft.service"
        "listen-minecraft.socket"
      ];
      after = [
        "hook-minecraft.service"
        "listen-minecraft.socket"
      ];
      serviceConfig.ExecStart = "${pkgs.systemd.out}/lib/systemd/systemd-socket-proxyd 127.0.0.1:${toString minecraft-port}";
      # this starts Minecraft is required
      # and wait for it to be available over TCP
      # to unlock listen-minecraft.service proxy
      systemd.services.hook-minecraft = {
        path = with pkgs; [
          systemd
          libressl
          busybox
        ];
        enable = true;
        serviceConfig = {
          ExecStartPost = "${wait-tcp.out}/bin/wait-tcp";
          ExecStart = "${start-mc.out}/bin/start-mc";
        };
      }; # create a timer running every frequency-check-players
      # that runs stop-minecraft.service script on a regular
      # basis to check if the server needs to be stopped
      systemd.timers.stop-minecraft = {
        enable = true;
        timerConfig = {
          OnCalendar = "${frequency-check-players}";
          Unit = "stop-minecraft.service";
        };
        wantedBy = [ "timers.target" ];
      };

      # run the script no-player-connected
      # and if it returns true, stop the minecraft-server
      # but also the timer and the hook-minecraft service
      # to prepare a working state ready to resume the
      # server again
      systemd.services.stop-minecraft = {
        enable = true;
        serviceConfig.Type = "oneshot";
        script = ''
          if ${no-player-connected}/bin/no-player-connected
          then
            echo "stopping server"
            systemctl stop minecraft-server.service
            systemctl stop hook-minecraft.service
            systemctl stop stop-minecraft.timer
          fi
        '';
      };
    };
  };
}
