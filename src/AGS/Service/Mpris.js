const M = await Service.import('mpris')

export const bindMpris =
  prop => () =>
    M.bind(prop)

export const disconnectMpris =
  handlerID => () =>
    M.disconnect(handlerID)

export const connectMpris =
  signal => callback => () =>
    M.connect(signal, callback)

export const players =
  () =>
    M.players

export const matchPlayerImpl =
  name => () =>
    M.getPlayer(name)

