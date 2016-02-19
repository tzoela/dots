import XMonad
import XMonad.Config.Desktop
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks

baseConfig = desktopConfig

main :: IO()
main = xmonad $ baseConfig {
      focusedBorderColor = "#ff6699" -- not a hook
    , startupHook = startupHook baseConfig <+> myHook
    , layoutHook = smartBorders (myLayout)
    , manageHook = myManageHooks
    } `additionalKeys` [
    ((0 , xF86XK_AudioLowerVolume), spawn "amixer set Master on && amixer set Headphone on && amixer set Master 2- unmute")
  , ((0 , xF86XK_AudioRaiseVolume), spawn "amixer set Master on && amixer set Headphone on && amixer set Master 2+ unmute")
  , ((0 , xF86XK_AudioMute), spawn "amixer set Headphone 100% && amixer set Master 100% && amixer set Master toggle && amixer set Headphone toggle&& amixer set Speaker toggle")
  ]

myLayout = (avoidStruts tiled) ||| Full
   where
      tiled   = Tall nmaster delta ratio
      nmaster = 1
      ratio   = 1/2
      delta   = 3/100

myManageHooks = composeAll [isFullscreen --> doFullFloat]

myHook :: X()
myHook = do
  spawnOnce "conky"
  spawn "amixer set -c 0 Headphone 100 unmute && amixer set -c 0 Master 100 unmute"
  spawnOnce "xmobar"
  spawnOnce "gnome-terminal"
  spawnOnce "emacs"
  spawnOnce "chromium-browser"
