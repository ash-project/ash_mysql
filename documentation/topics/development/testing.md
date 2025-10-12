<!--
SPDX-FileCopyrightText: 2024 Joel Kociolek
SPDX-FileCopyrightText: 2020 Zach Daniel

SPDX-License-Identifier: MIT
-->

# Testing With MySQL

Testing resources with MySQL generally requires passing `async?: false` to
your tests, due to `MySQL`'s limitation of having a single write transaction
open at any one time.

This should be coupled with to make sure that Ash does not spawn any tasks.

```elixir
config :ash, :disable_async?, true
```
