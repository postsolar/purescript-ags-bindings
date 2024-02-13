export const configDir =
  () =>
    App.configDir

export const windows =
  () =>
    App.windows

export const disconnectApp =
  handlerID => () =>
    App.disconnect(handlerID)

export const connectApp =
  signal => handler => () =>
    App.connect(signal, (_, ...args) => handler(...args))

export const addWindow =
  window => () =>
    App.addWindow(window)

export const removeWindow =
  window => () =>
    App.removeWindow(window)

export const getWindowImpl =
  name => () =>
    App.getWindow(name)

export const closeWindow =
  name => () =>
    App.closeWindow(name)

export const openWindow =
  name => () =>
    App.openWindow(name)

export const toggleWindow =
  name => () =>
    App.toggleWindow(name)

export const quit =
  () =>
    App.quit()

export const resetCss =
  () =>
    App.resetCss()

export const applyCss =
  path => () =>
    App.applyCss(path)

