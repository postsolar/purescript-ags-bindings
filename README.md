# purescript-ags-bindings

Low(ish)-level [AGS](https://github.com/Aylur/ags/) bindings for PureScript.

## Usage examples

Standalone subprojects in the `examples/` directory demonstrate how to use AGS with PureScript.
Head over to [`examples/README.md`](examples/README.md) for more information.

## Usage

This library can be used in different ways. An example setup would look as follows:

#### 1. Add an entrypoint module

Add a module which would serve as entrypoint to AGS.
It should export a value called `main` which would have the type `Effect { windows ∷ Array Window }`.

Then, create a file `entrypoint.js` which would setup AGS and re-export the windows from the PureScript module.

```js
import { main } from "./index.js"

// Any necessary AGS setup would go here
//
//

export default { windows: main().windows }
```

#### 2. Compile and bundle the project

```shell
> spago bundle --bundle-type module --bundler-args '--external:gi://*' --module '<entrypoint module>'
```

#### 3. Run AGS

```shell
> ags -c ./entrypoint.js
```

Or to run with GTK inspector:
```shell
> ags -c ./entrypoint.js -i
```

