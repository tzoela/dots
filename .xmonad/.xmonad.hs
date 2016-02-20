import XMonad
import XMonad.Config.Desktop
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.EZConfig(additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import Data.ByteString.UTF8 (fromString)


baseConfig = desktopConfig

main :: IO()
main = xmonad $ baseConfig {
      focusedBorderColor = "#ff6699" -- not a hook
    , startupHook = startupHook baseConfig <+> myHook
    , layoutHook = smartBorders (myLayout)
    , manageHook = myManageHooks
    } `additionalKeys` [
    ((0 , xF86XK_AudioLowerVolume), volumeDown)
  , ((0 , xF86XK_AudioRaiseVolume), volumeUp)
  , ((0 , xF86XK_AudioMute), toggleMute)
  ]

myLayout = (avoidStruts tiled) ||| Full
   where
      tiled   = Tall nmaster delta ratio
      nmaster = 1
      ratio   = 1/2
      delta   = 3/100

myManageHooks = composeAll [isFullscreen --> doFullFloat]

volumeUp :: X ()
volumeUp = changeVolume "2+" "notification-audio-volume-high" "Volume Up"

volumeDown :: X ()
volumeDown = changeVolume "2-" "notification-audio-volume-low" "Volume Down"

toggleMute :: X ()
toggleMute = do
  spawn "amixer set Headphone 100% && amixer set Master 100% && amixer set Master toggle && amixer set Headphone toggle&& amixer set Speaker toggle"
  spawn "killall notify-osd; notify-send \"Mute Toggle\" \"Who knows?\""

changeVolume :: String -> String -> String -> X ()
changeVolume diff icon text = do
  spawn ("amixer set Master on && amixer set Headphone on && amixer set Master " ++ diff ++ " unmute")
  spawn ("killall notify-osd; notify-send \"" ++ text ++ "\" \"$(~/.xmonad/get-volume)\" -i " ++ icon)


myHook :: X()
myHook = do
  spawn "amixer set -c 0 Headphone 100 unmute && amixer set -c 0 Master 100 unmute"
  spawn "xautolock -time 10 -locker lock"
  spawnOnce "xmobar"
  spawnOnce "gnome-terminal"
  spawnOnce "emacs"
  spawnOnce "chromium-browser"
