import Gio from 'gi://Gio'

Gio._promisify(Gio.OutputStream.prototype, 'write_bytes_async')

export const writeBytesAsyncImpl =
  priority => bytes => stream => () =>
    stream.write_bytes_async(bytes, priority, null)

