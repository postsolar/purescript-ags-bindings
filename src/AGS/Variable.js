export const set =
  f => v => () =>
    v.setValue(f(v.value))

export const bindValue =
  v =>
    v.bind("value")

export const store =
  v =>
    Variable(v)

export const poll =
  ({ initValue, interval, transform, command }) => () =>
    Variable(initValue, {
      poll: [ interval, command, transform ]
    })

export const serve =
  ({ initValue, interval, command }) => () =>
    Variable(initValue, {
      poll: [ interval, command ]
    })

export const listen =
  ({ initValue, command, transform }) => () =>
    { const v = Variable(initValue, {
        listen: [ command, msg => transform(v.value)(msg) ]
      })
      return v
    }

