// Props

export const iconTheme =
  () =>
    App.iconTheme

export const cursorTheme =
  () =>
    App.cursorTheme

export const gtkTheme =
  () =>
    App.gtkTheme

export const configPath =
  () =>
    App.configPath

export const configDir =
  () =>
    App.configDir

export const windows =
  () =>
    App.windows

// Signals

export const disconnectApp =
  handlerID => () =>
    App.disconnect(handlerID)

export const connectApp =
  signal => handler => () =>
    App.connect(signal, (_, ...args) => handler(...args))

// Methods

export const addIcons =
  path => () =>
    App.addIcons(path)

export const setIconTheme =
  theme => () =>
    App.iconTheme = theme

export const setCursorTheme =
  theme => () =>
    App.cursorTheme = theme

export const setGtkTheme =
  theme => () =>
    App.gtkTheme = theme

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

