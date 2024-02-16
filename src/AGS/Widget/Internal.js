export const unsafeSetProperty =
  prop => value => widget => () =>
    widget[prop] = value

export const grabFocus =
  widget => () =>
    widget.grab_focus()

export const withInterval =
  interval => handler => widget => () =>
    { widget.poll(interval, _ => handler())
      return
    }

