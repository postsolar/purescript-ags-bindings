# Changelog

## Unreleased

- Remove the need to wrap widget values with `asOneOf` (#7)
Any of the input record fields can now be either `a` or `Binding a`, as long as props of the widget have that field as `ValueOrBinding a`.

- Move all widgets into a single module (#7)
Modules for individual widgets like `AGS.Widget.Button` are removed.
Now widgets should only be imported from `AGS.widget`.

- Make `Applications.matchAppName` return `Boolean` rather than `Effect Boolean`

## v0.1.0
Initial release
