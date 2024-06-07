{
  description = "vkhashimoto's blog";

  inputs = {
    nixpkgs.url = "github:nixOS/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
  	flake-utils.lib.eachDefaultSystem (system:
			let
				pkgs = import nixpkgs {
					inherit system;
				};

			in with pkgs; rec { 
				#zlib = 
				czlib = pkgs.stdenv.mkDerivation {
					name = "zlib";
					version = "1.2.9";
					src = builtins.fetchTarball {
						url = "https://www.zlib.net/fossils/zlib-1.2.9.tar.gz";
						sha256 = "0k8b7zbai3k6wxp5sgffhm2qkn7dvwzxd300yardh3ygliy8b3cw"; #lib.fakeSha256;
					};

					installPhase = ''
						mkdir -p $out/lib
						cp libz.so.1 $out/lib/
					'';
				};
				devShells.default = mkShell {
					name = "plover";
					buildInputs = [ 
						czlib
						pkgs.python310
						pkgs.python310Packages.tox
						#pkgs.python310Packages.pyqt5_sip
						pkgs.python310Packages.pyqt5
						virtualenv
						pkg-config
						#libffi
						libsForQt5.full
						libsForQt5.qt5.qtbase
						python310Packages.setuptools
						python310Packages.xlib
						python310Packages.pip
						python310Packages.cffi
						python310Packages.xkbcommon
						libsForQt5.qt5ct
					];
					buildNativeInputs = [ 
						libffi 
						glibc
						glib
						libstdcxx5
						libgcc
						libGL
						#libz
						xorg.libxcb
						xorg.libXrender
						libxkbcommon
						fontconfig
						freetype
						xorg.libXext
						xorg.libX11
						xorg.libSM
						xorg.libICE
						libglibutil
						xorg.libXinerama
						#xorg.libpthreadstubs
						xorg.xcbutilwm
						xorg.xcbutilimage
						xorg.xcbutil
						xorg.xcbutilkeysyms
						xorg.xcbutilrenderutil
						dbus
					];
					shellHook = ''
						export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:${pkgs.glib.out}/lib:${pkgs.libGL}/lib:${pkgs.xorg.libxcb}/lib:$LD_LIBRARY_PATH"
						export LD_LIBRARY_PATH="${pkgs.xorg.libXrender}/lib:${pkgs.libxkbcommon}/lib:${pkgs.fontconfig.lib}/lib:${pkgs.freetype}/lib:$LD_LIBRARY_PATH"
						export LD_LIBRARY_PATH="${pkgs.xorg.libXext}/lib:${pkgs.xorg.libX11}/lib:${pkgs.xorg.libSM}/lib:${pkgs.xorg.libICE}/lib:${pkgs.libglibutil}/lib:$LD_LIBRARY_PATH"
						export LD_LIBRARY_PATH="${pkgs.xorg.libXinerama}/lib:${czlib}/lib:${pkgs.xorg.xcbutilwm}/lib:${pkgs.xorg.xcbutilimage}/lib:$LD_LIBRARY_PATH"
						export LD_LIBRARY_PATH="${pkgs.xorg.xcbutil}/lib:${pkgs.xorg.xcbutilkeysyms}/lib:${pkgs.xorg.xcbutilrenderutil}/lib:$LD_LIBRARY_PATH"
						export LD_LIBRARY_PATH="${pkgs.dbus.lib}/lib:$LD_LIBRARY_PATH"

						export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.libsForQt5.qt5.qtbase.bin}/lib/qt-${pkgs.libsForQt5.qt5.qtbase.version}/plugins/platforms"
						export QT_QPA_PLUGIN_PATH="${pkgs.libsForQt5.qt5.qtbase.bin}/lib/qt-${pkgs.libsForQt5.qt5.qtbase.version}/plugins"

						export PATH="${pkgs.libsForQt5.qt5.qtbase.bin}/lib/qt-${pkgs.libsForQt5.qt5.qtbase.version}/plugins:$PATH"
						export QT_QPA_PLATFORM=xcb
						export QT_DEBUG_PLUGINS=1
						echo "Entered development environment"
					'';
				};
				#packages.dev = pkgs.stdenv.mkDerivation {
				#	name = "dev";
				#	src = ./.;
				#	buildInputs = [ bun ];
				#	installPhase = ''
				#		mkdir -p $out/bin
				#		cp -rv $src/* $out

				#		echo "${bun}/bin/bun run dev" >> $out/bin/dev
				#		chmod +x $out/bin/dev
				#	'';
				#};
			}
		);

  
}
