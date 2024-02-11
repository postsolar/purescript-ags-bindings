# Example bar configuration

This project demonstrates usage of `purescript-ags-bindings` for a simple bar with a Hyprland workspace switcher.

The bar uses the default GTK theme with no extra styling and is divided into 3 sections:
  - On the left there is a Hyprland workspace switcher. It displays non-empty workspaces which can be clicked on to jump to the chosen workspace.
  - In the center, current date and time are displayed. Clicking on it toggles the display formatting between short and long format.
  - On the right, there are two icons: one for system information (RAM, swap and CPU usage) and one for volume.
    Clicking on an icon toggles its visibility.

### Dependencies

Dependencies for running this project consist of:

  - `Hyprland`
  - `pamixer` and `pactl`
  - `jc`
  - `rg`

### Building

See building instructions in the parent directory's `README.md`

