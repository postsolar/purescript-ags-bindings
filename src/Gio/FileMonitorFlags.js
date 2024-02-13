import Gio from 'gi://Gio'

export const none = Gio.FileMonitorFlags.NONE
export const sendMoved = Gio.FileMonitorFlags.SEND_MOVED
export const watchHardLinks = Gio.FileMonitorFlags.WATCH_HARD_LINKS
export const watchMounts = Gio.FileMonitorFlags.WATCH_MOUNTS
export const watchMoves = Gio.FileMonitorFlags.WATCH_MOVES

