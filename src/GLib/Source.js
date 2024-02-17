import GLib from 'gi://GLib'

export const destroy =
  source => () =>
    source.destroy()

export const sourceRemove =
  id => () =>
    GLib.source_remove(id)

