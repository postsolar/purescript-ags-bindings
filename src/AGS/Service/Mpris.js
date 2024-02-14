const M = await Service.import('mpris')

// *** Mpris

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

// *** Player

export const fromPlayer =
  ({ ...props }) =>
    props

