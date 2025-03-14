#!/usr/bin/env bash

# --- Build configuration ---
#

action=$(tr '[:upper:]' '[:lower:]' <<< "$1")
os=$(tr '[:upper:]' '[:lower:]' <<< "$2")
build_system=$(tr '[:upper:]' '[:lower:]' <<< "$3")

if [ -z "$action" ] || [ -z "$os" ] || [ -z "$build_system" ]; then
  echo 'Invalid or missing input parameters'
  exit 1
fi

if [[ "$os" != windows* ]]; then
  _sudo='sudo'
fi

if [ -d 'audacious' ]; then
  cd audacious
fi

case "$action" in
  configure)
    case "$os" in
      ubuntu-20.04 | windows*)
        if [ "$build_system" = 'meson' ]; then
          meson setup build
        else
          ./autogen.sh && ./configure
        fi
        ;;

      ubuntu*)
        if [ "$build_system" = 'meson' ]; then
          meson setup build
        else
          ./autogen.sh && ./configure
        fi
        ;;

      macos-13)
        export PATH="/usr/local/opt/qt@5/bin:$PATH"
        export PKG_CONFIG_PATH="/usr/local/opt/qt@5/lib/pkgconfig:$PKG_CONFIG_PATH"

        if [ "$build_system" = 'meson' ]; then
          meson setup build -D qt5=true -D gtk=false
=======
          meson setup build -D gtk3=true
>>>>>>> parent of 784d51858 (meson: Change default Qt version to 6)
        else
          ./autogen.sh && ./configure --enable-gtk3
        fi
        ;;

      macos*)
          export PATH="/usr/local/opt/qt@5/bin:$PATH"
          export PKG_CONFIG_PATH="/usr/local/opt/qt@5/lib/pkgconfig:$PKG_CONFIG_PATH"

        if [ "$build_system" = 'meson' ]; then
          meson setup build -D qt6=true -D gtk=false
        else
          export LDFLAGS="-L/opt/homebrew/opt/libiconv/lib"
          export CPPFLAGS="-I/opt/homebrew/opt/libiconv/include"
          ./autogen.sh && ./configure --disable-gtk
        fi
        ;;

      *)
        echo "Unsupported OS: $os"
        exit 1
        ;;
    esac
    ;;

  build)
    if [ "$build_system" = 'meson' ]; then
      meson compile -C build
    elif [[ "$os" == macos* ]]; then
      make -j$(sysctl -n hw.logicalcpu)
    else
      make -j$(nproc)
    fi
    ;;

  test)
    cd src/libaudcore/tests
    if [ "$build_system" = 'meson' ]; then
      meson setup build && meson test -v -C build
    elif [[ "$os" == macos* ]]; then
      make -j$(sysctl -n hw.logicalcpu) test && ./test
    else
      make -j$(nproc) test && ./test
    fi
    ;;

  install)
    if [ "$build_system" = 'meson' ]; then
      $_sudo meson install -C build
    else
      $_sudo make install
    fi
    ;;

  *)
    echo "Unsupported action: $action"
    exit 1
    ;;
esac
