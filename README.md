# macOS crossover-sources wine build script

follow [this](https://codetinkering.com/switch-homebrew-arm-x86/) first to install homebrew arm

### why not macports? 

it's broken in [multiple](https://trac.macports.org/ticket/71668) [ways](https://trac.macports.org/ticket/72189), and homebrew is just simpler as a result.

as per guidance from macports;

> If you're trying to build x86_64 on arm by setting build_arch to x86_64, you're probably in for a world of hurt. Although Rosetta-targeted builds work in a few cases via this method, they often don't due to architecture checks that don't go by build_arch.
