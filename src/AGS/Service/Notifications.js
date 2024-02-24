const N = await Service.import('notifications')

// Notifications signals

export const connectNotifications =
  signal => callback => () =>
    N.connect(signal, (_, ...args) => callback(...args))

export const disconnectNotifications =
  handlerID => () =>
    N.disconnect(handlerID)

// Notifications bindings and props

export const bindNotifications =
  prop => () =>
    N.bind(prop)

export const getOptionsImpl =
  ks => () =>
    Object.fromEntries(ks.map(k => [k, N[k]]))

export const setOptionsImpl =
  opts => () =>
    Object.entries(opts).forEach(([k, v]) => N[k] = v)

export const notifications =
  () =>
    N.notifications

export const popups =
  () =>
    N.popups

// Notifications methods

export const clear = N.clear
export const getNotificationImpl = N.getNotification
export const getPopupImpl = N.getPopup

// Notification methods

export const dismiss =
  n => () =>
    n.dismiss()

export const close =
  n => () =>
    n.close()

export const invoke =
  n => action => () =>
    n.invoke(action.id)

