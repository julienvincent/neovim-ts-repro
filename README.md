# Repro-Repo for Neovim Tree-Sitter issue

This is a reproduce repo for an issue I am running into with treesitter on neovim nightly.

This shows a test case for calling the TSNode:next_named_sibling() API on a node that has siblings. On neovim@0.10.2
this returns the sibling node as expected but returns `nil` on nightly.

#### Instructions

This uses [Just](https://github.com/casey/just) to run (see [the justfile](./justfile)).

### Working Case

To run the **working** test-case you can run:

```bash
just test
# or
just test stable
# or any release version
just test v0.10.2
```

This should print something like:

<details>
  <summary>Test output</summary>

```bash
========================================
Testing:        /Users/julienvincent/code/neovim-ts-repro/tests/ts-repro/ts_spec.lua
Success ||      treesitter-test should find a nodes named sibling

Success:        1
Failed :        0
Errors :        0
========================================
```
</details>

### Failing Case

Now run this against nightly to see the failing case

```bash
just test nightly
```

You will see something like

<details>
  <summary>Test output</summary>

```bash
========================================
Testing:        /Users/julienvincent/code/neovim-ts-repro/tests/ts-repro/ts_spec.lua
Fail    ||      treesitter-test should find a nodes named sibling
            ...nvincent/code/neovim-ts-repro/tests/ts-repro/ts_spec.lua:25: Expected objects to not be the same.
            Passed in:
            (nil)
            Did not expect:
            type nil

            stack traceback:
                ...nvincent/code/neovim-ts-repro/tests/ts-repro/ts_spec.lua:25: in function <...nvincent/code/neovim-ts-repro/tests/ts-repro/ts_spec.lua:4>


Success:        0
Failed :        1
Errors :        0
========================================
```
</details>

---

See [ts_spec.lua](./tests/ts-repro/ts_spec.lua) for the code.

---

This project was extracted from https://github.com/julienvincent/nvim-paredit which is where this issue was originally
discovered.
