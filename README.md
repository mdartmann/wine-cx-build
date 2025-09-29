# macOS crossover-sources wine build script

based on [Gcenx/crossover-wine-ci](https://github.com/Gcenx/crossover-wine-ci) and [yretenal/wine-cx-build](https://github.com/yretenai/wine-cx-build)

## usage

- follow [this guide](https://codetinkering.com/switch-homebrew-arm-x86/) first to install homebrew for both x86_64 and arm
- run build.sh (this can take a while!)
- to use wine, use the binary under `./install/wine-cx${CROSS_OVER_VERSION}/bin/wineloader`
- for winetricks and other tools, `export WINE=${PWD}/install/wine-cx${CROSS_OVER_VERSION}/bin/wineloader`
  - note: winetricks will not let you set wine to older windows versions than XP, even though this build does support this; just run `wineloader winecfg` and set the windows version under `Applications -> Windows Version`

### why not macports?

it's broken in [multiple](https://trac.macports.org/ticket/71668) [ways](https://trac.macports.org/ticket/72189), and homebrew is just simpler as a result.

as per guidance from macports;

> If you're trying to build x86_64 on arm by setting build_arch to x86_64, you're probably in for a world of hurt. Although Rosetta-targeted builds work in a few cases via this method, they often don't due to architecture checks that don't go by build_arch.
