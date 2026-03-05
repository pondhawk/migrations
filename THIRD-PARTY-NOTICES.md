# Third-Party Notices

This project includes vendored (forked) copies of the following open-source software.

## DbUp

- **Source:** https://github.com/DbUp/DbUp
- **License:** MIT
- **Copyright:** Copyright (c) DbUp Contributors 2015
- **Vendored directories:**
  - `src/dbup-core/`
  - `src/dbup-mysql/`
  - `src/dbup-postgresql/`
  - `src/dbup-sqlite/`
  - `src/dbup-sqlserver/`

### Modifications

This fork extends DbUp with the following changes to its internal execution pipeline:

- Added `RunGroupOrder` property on `SqlScriptOptions` for ordered script groups
- Added `ScriptType.RunAlways` for scripts that execute every run without journaling
- Added sorting by `RunGroupOrder` in `UpgradeEngine` (pre-run before main before post-run)
- Added filter bypass for `RunAlways` scripts in `DefaultScriptFilter`
- Added explicit transaction rollback on failure in `SingleTransactionStrategy`
- Fixed `HashSet` comparer mismatch in `UpgradeEngine`

### DbUp MIT License

```
MIT License

Copyright (c) DbUp Contributors 2015

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
