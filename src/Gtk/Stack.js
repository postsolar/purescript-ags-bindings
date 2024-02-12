import Gtk from 'gi://Gtk?version=3.0'

export const transitions = {
  'none': Gtk.StackTransitionType.NONE,
  'crossfade': Gtk.StackTransitionType.CROSSFADE,
  'slideRight': Gtk.StackTransitionType.SLIDE_RIGHT,
  'slideLeft': Gtk.StackTransitionType.SLIDE_LEFT,
  'slideUp': Gtk.StackTransitionType.SLIDE_UP,
  'slideDown': Gtk.StackTransitionType.SLIDE_DOWN,
  'slideLeftRight': Gtk.StackTransitionType.SLIDE_LEFT_RIGHT,
  'slideUpDown': Gtk.StackTransitionType.SLIDE_UP_DOWN,
  'overUp': Gtk.StackTransitionType.OVER_UP,
  'overDown': Gtk.StackTransitionType.OVER_DOWN,
  'overLeft': Gtk.StackTransitionType.OVER_LEFT,
  'overRight': Gtk.StackTransitionType.OVER_RIGHT,
  'underUp': Gtk.StackTransitionType.UNDER_UP,
  'underDown': Gtk.StackTransitionType.UNDER_DOWN,
  'underLeft': Gtk.StackTransitionType.UNDER_LEFT,
  'underRight': Gtk.StackTransitionType.UNDER_RIGHT,
  'overUpDown': Gtk.StackTransitionType.OVER_UP_DOWN,
  'overDownUp': Gtk.StackTransitionType.OVER_DOWN_UP,
  'overLeftRight': Gtk.StackTransitionType.OVER_LEFT_RIGHT,
  'overRightLeft': Gtk.StackTransitionType.OVER_RIGHT_LEFT
}
