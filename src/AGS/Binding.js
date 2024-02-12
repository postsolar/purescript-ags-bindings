export const transform =
  f => binding =>
    binding.transform(f)

export const pureBinding =
  value =>
    Variable(value).bind("value")

export const applyBinding =
  mf => ma =>
    Utils.merge([mf, ma], (f, a) => f(a))

export const bindBinding =
  b1 => fn =>
    { const b2 = fn(b1.transformFn(b1.emitter[b1.prop]))
      const watcher = Variable(b2.transformFn(b2.emitter[b2.prop0]))
      for (const b of [b1, b2])
        b.emitter.connect("changed", () => {
          const b2 = fn(b1.transformFn(b1.emitter[b1.prop]))
          watcher.setValue(b2.transformFn(b2.emitter[b2.prop]))
        })
      return watcher.bind()
    }

