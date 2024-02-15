const M = await Service.import('mpris')

// *** Mpris

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
