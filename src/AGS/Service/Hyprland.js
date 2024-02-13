const H = await Service.import('hyprland')

export const bindHyprland =
  prop => () =>
    H.bind(prop)

export const bindHyprlandActive =
  prop => () =>
    H.active.bind(prop)

export const disconnectHyprland =
  id => () =>
    H.disconnect(id)

export const disconnectHyprlandActive =
  id => () =>
    H.active.disconnect(id)

export const connectHyprland =
  signal => handler => () =>
    H.connect(signal, (_, ...args) => handler(...args))

export const connectHyprlandActive =
  signal => handler => () =>
    H.active.connect(signal, (_, ...args) => handler(...args))

export const message =
  command => () =>
    H.message(command)

export const messageAsyncImpl =
  command => () =>
    H.messageAsync(command)

export const getMonitorImpl =
  id => () =>
    H.getMonitor(id)

export const getWorkspaceImpl =
  id => () =>
    H.getWorkspace(id)

export const getClientImpl =
  address => () =>
    H.getClient(address)

