const monitors = new Map

export const monitorImpl =
  (flags, file) =>
    file.monitor(flags, null)

export const monitorFileImpl =
  (flags, file) =>
    file.monitor_file(flags, null)

export const monitorDirectoryImpl =
  (flags, file) =>
    file.monitor_directory(flags, null)

export const registerMonitorImpl =
  monitor =>
    { monitors.set(monitor, true)
      monitor.connect('notify::cancelled', () => monitors.delete(mon))
    }

export const cancel =
  monitor => () =>
    { monitor.cancel()
      return
    }

