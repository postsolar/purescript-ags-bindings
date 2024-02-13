import Gio from 'gi://Gio'

export const attributeChanged = Gio.FileMonitorEvent.ATTRIBUTE_CHANGED
export const changed = Gio.FileMonitorEvent.CHANGED
export const changesDoneHint = Gio.FileMonitorEvent.CHANGES_DONE_HINT
export const created = Gio.FileMonitorEvent.CREATED
export const deleted = Gio.FileMonitorEvent.DELETED
export const moved = Gio.FileMonitorEvent.MOVED
export const movedIn = Gio.FileMonitorEvent.MOVED_IN
export const movedOut = Gio.FileMonitorEvent.MOVED_OUT
export const preUnmount = Gio.FileMonitorEvent.PRE_UNMOUNT
export const renamed = Gio.FileMonitorEvent.RENAMED
export const unmounted = Gio.FileMonitorEvent.UNMOUNTED

