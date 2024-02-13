import GLib from 'gi://GLib'

export const fromString =
  string =>
    new GLib.Bytes(new TextEncoder('utf-8').encode(string))

export const fromUint8Array =
  bytes =>
    new GLib.Bytes(bytes)

export const toUint8Array =
  bytes =>
    bytes.get_data()

