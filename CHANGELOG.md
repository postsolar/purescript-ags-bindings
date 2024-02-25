# Changelog

## Unreleased

- Add a notifications daemon example

- Add `Utils.lookupIcon` and `Gtk.IconInfo.filename` (#6)

- Add `Binding.overBoth'` and remove constraints from `overValue`, `overBinding` and `overBoth`

- Add `Widget.destroy`

## v0.2.0

- Refactor GObject type classes (#14)

- Refactor service type classes (#13)

- Add `Notifications` service (#11)

- Update AGS and integrate recent changes (up to and incl. 5e3f479) (#8)

- Amend the types of some fields of `Mpris.PlayerRecord` (#8)
Now instead of `Nullable a` and `UndefinedOr a`, all fields which are not guaranteed to be present are `Maybe a`.

- Fix implementation of `Mpris.matchPlayer` (#8)

- Fix implementation of `Mpris.fromPlayer` (#8)

- Remove the need to wrap widget values with `asOneOf` (#7)
Any of the input record fields can now be either `a` or `Binding a`, as long as props of the widget have that field as `ValueOrBinding a`.

- Move all widgets into a single module (#7)
Modules for individual widgets like `AGS.Widget.Button` are removed.
Now widgets should only be imported from `AGS.widget`.

- Make `Applications.matchAppName` return `Boolean` rather than `Effect Boolean`

## v0.1.0
Initial release
