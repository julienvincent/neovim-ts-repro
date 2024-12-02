[macos]
prepare-nvim channel:
  #!/usr/bin/env bash
  set -eo pipefail

  NVIM_DIR=".build/nvim/{{ channel }}"

  test -d $NVIM_DIR || {
    mkdir -p $NVIM_DIR

    # Older versions of nvim don't have arch specific releases - so we do a simple retry without the arch component.
    curl -L https://github.com/neovim/neovim/releases/download/{{ channel }}/nvim-macos-$(arch).tar.gz --fail > ./.build/nvim-macos.tar.gz || \
    curl -L https://github.com/neovim/neovim/releases/download/{{ channel }}/nvim-macos.tar.gz --fail > ./.build/nvim-macos.tar.gz

    xattr -c ./.build/nvim-macos.tar.gz
    tar xzf ./.build/nvim-macos.tar.gz -C $NVIM_DIR --strip-components=1
    rm ./.build/nvim-macos.tar.gz
  }

[linux]
prepare-nvim channel:
  #!/usr/bin/env bash
  set -eo pipefail

  NVIM_DIR=".build/nvim/{{ channel }}"

  test -d $NVIM_DIR || {
    mkdir -p $NVIM_DIR

    curl -L https://github.com/neovim/neovim/releases/download/{{ channel }}/nvim-linux64.tar.gz > ./.build/nvim-linux64.tar.gz
    tar xzf ./.build/nvim-linux64.tar.gz -C $NVIM_DIR --strip-components=1
    rm ./.build/nvim-linux64.tar.gz
  }

prepare-dependencies:
  #!/usr/bin/env bash
  test -d .build/dependencies || {
    mkdir -p ./.build/dependencies
    git clone --depth 1 https://github.com/nvim-lua/plenary.nvim ./.build/dependencies/plenary.nvim
    git clone --depth 1 https://github.com/nvim-treesitter/nvim-treesitter ./.build/dependencies/nvim-treesitter
  }

prepare channel: (prepare-nvim channel) prepare-dependencies

test channel="stable": (prepare channel)
  #!/usr/bin/env bash
  set -eo pipefail

  NVIM_DIR=".build/nvim/{{ channel }}"

  ./$NVIM_DIR/bin/nvim --version
  XDG_CONFIG_HOME=$(pwd)/tests/ \
  XDG_DATA_HOME=$(pwd)/.build/data \
  XDG_CACHE_HOME=$(pwd)/.build/cache \
  ./$NVIM_DIR/bin/nvim \
    --headless \
    --noplugin \
    -u tests/config.lua \
    -c "PlenaryBustedDirectory tests/ts-repro { minimal_init='tests/config.lua', sequential=true }"

