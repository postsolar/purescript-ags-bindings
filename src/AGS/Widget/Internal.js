export const grabFocus =
  widget => () =>
    widget.grab_focus()

export const withInterval =
  interval => handler => widget => () =>
    { widget.poll(interval, _ => handler())
      return
    }

export const unsafeGetwidgetPropsImpl =
  ks => widget =>
    Object.fromEntries(ks.map(k => [k, widget[k]]))

export const unsafeUpdateWidgetProps =
  props => widget => () =>
    Object.entries(props).forEach(([k, v]) => {
      if (widget[k] != v)
        widget[k] = v
    })

