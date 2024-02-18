# Examples directory

Each subdirectory here is a standalone mini-project which demonstrates how to use `purescript-ags-bindings`.
To build a project, change into its directory and build and bundle it with Spago.
A sample entrypoint JS file is provided for reference as well.

```shell
cd <project-name>
spago bundle --bundle-type module --bundler-args '--external:gi://*'
ags -c ./entrypoint.js
```

