import { Binding } from 'resource:///com/github/Aylur/ags/service.js'

export const unsafeGetwidgetPropsImpl =
  ks => widget =>
    Object.fromEntries(ks.map(k => [k, widget[k]]))

export const unsafeUpdateWidgetProps =
  props => widget => () =>
    Object.entries(props).forEach(([k, v]) => {
      if (widget[k] != v)
        widget[k] = v
    })

export const isBinding =
  v =>
    v instanceof Binding

// Widgets

export const boxImpl = Widget.Box
export const buttonImpl = Widget.Button
export const centerBoxImpl = Widget.CenterBox
export const circularProgressImpl = Widget.CircularProgress
export const entryImpl = Widget.Entry
export const eventBoxImpl = Widget.EventBox
export const iconImpl = Widget.Icon
export const labelImpl = Widget.Label
export const menuImpl = Widget.Menu
export const menuItemImpl = Widget.MenuItem
export const overlayImpl = Widget.Overlay
export const progressBarImpl = Widget.ProgressBar
export const revealerImpl = Widget.Revealer
export const scrollableImpl = Widget.Scrollable
export const sliderImpl = Widget.Slider
export const stackImpl = Widget.Stack

