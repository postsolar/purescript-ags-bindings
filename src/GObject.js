export const connectImpl =
  (signal, handler, object) =>
    object.connect(signal, handler)

export const disconnectImpl =
  (object, handlerID) =>
    object.disconnect(handlerID)

