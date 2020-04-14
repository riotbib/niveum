{ pkgs, lib, ... }:
let
  nachtischsatan-bot = { token }: pkgs.writers.writePython3 "nachtischsatan-bot" {
    libraries = [ pkgs.python3Packages.python-telegram-bot ];
  } ''
    import random
    import time

    from telegram.ext import Updater, MessageHandler
    from telegram.ext.filters import Filters


    def flubber(bot, update):
        time.sleep(random.randrange(4000) / 1000)
        update.message.reply_text("*flubberflubber*")


    updater = Updater(
      '${token}'
    )

    updater.dispatcher.add_handler(MessageHandler(Filters.all, flubber))

    updater.start_polling()
    updater.idle()
  '';
in
{
  systemd.services.telegram-nachtischsatan = {
    wantedBy = [ "multi-user.target" ];
    description = "*flubberflubber*";
    enable = true;
    script = toString (nachtischsatan-bot {
      token = lib.strings.fileContents <secrets/telegram/nachtischsatan.token>;
    });
    serviceConfig.Restart = "always";
  };
}