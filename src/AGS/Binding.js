export const transform =
  f => binding =>
    binding.transform(f)

export const pureBinding =
  value =>
    Variable(value).bind("value")

export const bindBinding =
  binding => f =>
    binding.transform(a => {
      const { transformFn, emitter, prop } = f(a)
      return transformFn(emitter[prop])
    })

