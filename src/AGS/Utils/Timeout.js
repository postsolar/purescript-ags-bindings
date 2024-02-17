export const intervalImpl =
  (ms, callback, widget) =>
    widget === undefined
      ? Utils.interval(ms, callback)
      : Utils.interval(ms, callback, widget)

