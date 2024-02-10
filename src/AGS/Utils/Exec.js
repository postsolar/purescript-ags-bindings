export const exec =
  cmd => () =>
    Utils.exec(cmd)

export const execAsync =
  cmd => () =>
    Utils.execAsync(cmd)

export const subprocessImpl =
  ({ command, callback, onError, widget }) => () =>
    { const args =
        [ command ].concat(
          callback ? x => callback(x)() : [],
          onError ? x => onError(x)() : [],
          widget ? widget : []
        )
      return Utils.subprocess(...args)
    }

