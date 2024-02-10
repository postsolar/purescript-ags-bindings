export const connectImpl =
  handler => signal => object => () =>
    object.connect(signal, handler)

export const disconnectImpl =
  object => handlerID => () =>
    object.disconnect(handlerID)

