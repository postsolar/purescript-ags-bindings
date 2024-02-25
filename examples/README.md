# Examples directory

Each subdirectory here is a standalone mini-project which demonstrates how to use `purescript-ags-bindings`.
To build a project, change into its directory, then build and bundle it with Spago.
For each project, a sample entrypoint JS file is provided for reference as well.

```shell
cd <project-name>
spago bundle --bundle-type module --bundler-args '--external:gi://*' --bundler-args '--external:resource://*'
ags -c ./entrypoint.js
```

