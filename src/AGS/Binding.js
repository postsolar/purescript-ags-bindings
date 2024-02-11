export const transform =
  f => binding =>
    binding.transform(f)

export const pureBinding =
  value =>
    Variable(value).bind("value")

// TODO: FIXME: this might eventually get pushed upstream, remove it
const combineBindings = (deps, fn) => {
  const update = () => fn(...deps.map(d => d.transformFn(d.emitter[d.prop])))
  const watcher = Variable(update())

  for (const dep of deps)
    dep.emitter.connect("changed", () => watcher.setValue(update()))

  return watcher.bind()
}

export const applyBinding =
  mf => ma =>
    combineBindings([mf, ma], (f, a) => f(a))

export const bindBinding =
  b1 => fn =>
    { const b2 = fn(b1.transformFn(b1.emitter[b1.prop]))
      const watcher = Variable(b2.emitter[b2.prop])
      for (const b of [b1, b2])
        b.emitter.connect("changed", () => {
          const b2 = fn(b1.emitter[b1.prop])
          watcher.setValue(b2.emitter[b2.prop])
        })
      return watcher.bind()
    }

