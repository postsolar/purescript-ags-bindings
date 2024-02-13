import Gio from 'gi://Gio'

// This makes async File methods return Promises and not require a callback to be passed.
// Gio._promisify(Gio.File.prototype, 'copy_async')
Gio._promisify(Gio.File.prototype, 'create_async')
// Gio._promisify(Gio.File.prototype, 'delete_async')
// Gio._promisify(Gio.File.prototype, 'enumerate_children_async')
Gio._promisify(Gio.File.prototype, 'load_contents_async')
Gio._promisify(Gio.File.prototype, 'make_directory_async')
// Gio._promisify(Gio.File.prototype, 'move_async')
// Gio._promisify(Gio.File.prototype, 'open_readwrite_async')
// Gio._promisify(Gio.File.prototype, 'query_info_async')
Gio._promisify(Gio.File.prototype, 'replace_contents_async')
Gio._promisify(Gio.File.prototype, 'replace_contents_bytes_async', 'replace_contents_finish')
// Gio._promisify(Gio.File.prototype, 'trash_async')

export const fromPath =
  Gio.File.new_for_path

export const fromURI =
  Gio.File.new_for_uri

export const createAsyncImpl =
  flags => priority => file => () =>
    file.create_async(flags, priority, null)

export const replaceContentsBytesAsyncImpl =
  mkBkup => flags => bytes => file => () =>
    file.replace_contents_bytes_async(bytes, null, mkBkup, flags, null)
      // Ignore the returned etag as it's not typed yet
      .then(_ => { return })

// From the docs it's not clear what is the purpose of a boolean indicating
// success (the first element of returend tuple) because the method just
// throws when there are problems. As such we choose to ignore it.
export const loadContents =
  file => () =>
    file.load_contents(null)[1]

export const loadContentsAsyncImpl =
  file => () =>
    file
      .load_contents_async(null)
      .then(([bytes, _]) => bytes)

// As before, ignore the resulting boolean
export const makeDirectorySync =
  path => () =>
    { path.make_directory(null)
      return
    }

export const makeDirectoryAsyncImpl =
  priority => path => () =>
    path.make_directory_async(priority, null)

export const makeDirectoryRecursive =
  path => () =>
    path.make_directory_with_parents(null)

