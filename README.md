# purescript-ags-bindings

WIP [AGS](https://github.com/Aylur/ags/) bindings for PureScript.

## Development

#### 0. [Optional] Load the Nix shell

With flakes and `direnv`:

```shell
> echo 'use flake' > .envrc
> direnv allow
```

With flakes:

```shell
> nix develop
> exec $SHELL
```

#### 1. Add an entrypoint module

Add a module which would serve as entrypoint to AGS.
It should export a value called `main` which would have the type `Effect { windows ∷ Array Window }`.

#### 2. Compile and bundle the project

```shell
> spago build
> purs-backend-es bundle-module -m '<entrypoint module>'
```

#### 3. Run AGS

```shell
> ags --bus-name ags-dev -c ./entrypoint.js
```

Or to run with GTK inspector:
```shell
> ags --bus-name ags-dev -c ./entrypoint.js -i
```

