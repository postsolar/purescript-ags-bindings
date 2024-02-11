# Examples directory

Each subdirectory here is a standalone mini-project which demonstrates how to use `purescript-ags-bindings`.
To build a project, change into its directory, build it with Spago and bundle it with `purs-backend-es`.
A sample entrypoint JS file is provided for reference as well.

```shell
cd <project-name>
spago build && purs-backend-es bundle-module
ags -c ./entrypoint.js
```

