export const connectImpl =
  (signal, object, handler) =>
    object.connect(signal, handler)

export const disconnectImpl =
  (object, handlerID) =>
    object.disconnect(handlerID)

export const unsafeCopyGObjectImpl =
  ks => obj =>
    { const out = {}
      ks.forEach(k => out[k] = obj[k])
      return out
    }

