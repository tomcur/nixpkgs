{ lib
, wakatime, vscode-utils }:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;
in
  buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-wakatime";
      publisher = "WakaTime";
      version = "4.0.9";
      sha256 = "0sm2fr9zbk1759r52dpnz9r7xbvxladlpinlf2i0hyaa06bhp3b1";
    };

    postPatch = ''
      mkdir -p wakatime-master
      cp -rt wakatime-master --no-preserve=all ${wakatime}/lib/python*/site-packages/wakatime
    '';

    meta = with lib; {
      description = ''
        Visual Studio Code plugin for automatic time tracking and metrics generated
        from your programming activity
      '';
      license = licenses.bsd3;
      maintainers = with maintainers; [
        eadwu
      ];
    };
  }
