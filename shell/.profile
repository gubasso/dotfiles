for d in \
  .local/bin \
  .cargo/bin \
  .npm-global/bin \
  ; do
  PATH="$HOME/$d:$PATH"
done
export PATH

export TERMINAL=ghostty
export EDITOR=nvim
export VISUAL=$EDITOR
export SUDO_EDITOR=$EDITOR

export DISPLAY=:0
export QT_QPA_PLATFORM=wayland

# Firefox: Wayland + NVIDIA
export LIBVA_DRIVER_NAME=nvidia
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export MOZ_DISABLE_RDD_SANDBOX=1
export MOZ_ENABLE_WAYLAND=1
