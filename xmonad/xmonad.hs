---------------------------------------------------------------------------
--                                                                       --
--     _|      _|  _|      _|                                      _|    --
--       _|  _|    _|_|  _|_|    _|_|    _|_|_|      _|_|_|    _|_|_|    --
--         _|      _|  _|  _|  _|    _|  _|    _|  _|    _|  _|    _|    --
--       _|  _|    _|      _|  _|    _|  _|    _|  _|    _|  _|    _|    --
--     _|      _|  _|      _|    _|_|    _|    _|    _|_|_|    _|_|_|    --
--                                                                       --
---------------------------------------------------------------------------
-- Imports.
import qualified Data.Map        as M
import Data.Ratio

import XMonad
import XMonad.Hooks.DynamicLog

import XMonad.Hooks.ManageDocks

-- import XMonad.Util.EZConfig(additionalKeys, additionalKeysP)
import XMonad.Util.EZConfig        -- append key/mouse bindings
import XMonad.Actions.CycleWS
import XMonad.Layout.Combo
import XMonad.Layout.Grid
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.TwoPane
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Circle
import XMonad.Layout.MosaicAlt
import XMonad.Layout.Spiral
import XMonad.Actions.GridSelect

import System.Environment

import XMonad.Operations


import XMonad.Actions.SpawnOn
import XMonad.Hooks.SetWMName

import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers

myStartupHook = setWMName "LG3D"
                >> spawnHere "killall stalonetray; stalonetray"
                >> spawn "killall compton; compton -CG  --backend glx --vsync opengl-swc --paint-on-overlay"
                >> spawn "setxkbmap ca multi"
                >> spawn "xset s blank && xset s 180 && xset dpms 0 360 420" -- Set screen blank after 3 min, turn off after 6 min. and suspend after 7 min.
                >> spawn "xrdb -load ~/.Xresources" -- load .Xresources. I mainly want solarized dark as solarized theme.

-- The main function.
main = xmonad =<< statusBar myBar myXmobarPP toggleStrutsKey myConfig

-- Command to launch the bar.
myBar = "xmobar"

-- Custom PP.
myXmobarPP = xmobarPP
               { ppCurrent = xmobarColor "#f8f8f8" "DodgerBlue4" . wrap " " " "
               , ppVisible = xmobarColor "#f8f8f8" "LightSkyBlue4" . wrap " " " "
               , ppUrgent  = xmobarColor "#f8f8f8" "red4" . wrap " " " " . xmobarStrip
               , ppLayout  = wrap "" "" . xmobarColor "DarkOrange" "" . wrap " [" "] "
               , ppTitle   = xmobarColor "#61ce3c" "" . shorten 50
               , ppSep     = ""
               , ppWsSep   = " "
               }

-- Keybinding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

altMask = mod1Mask
myModMask = mod4Mask

myTerminal = "export TERM=xterm-256color ; alacritty"

myWorkSpaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

-- Layouts
-- basicLayout = Tall nmaster delta ratio where
--     nmaster = 1
--     delta   = 3/100
--     ratio   = 1/2
-- tallLayout       = named "tall"     $ avoidStruts $ basicLayout
-- wideLayout       = named "wide"     $ avoidStruts $ Mirror basicLayout
-- singleLayout     = named "single"   $ avoidStruts $ noBorders Full
-- circleLayout     = named "circle"   $ Circle
-- twoPaneLayout    = named "two pane" $ TwoPane (2/100) (1/2)
-- mosaicLayout     = named "mosaic"   $ MosaicAlt M.empty
-- gridLayout       = named "grid"     $ Grid
-- spiralLayout     = named "spiral"   $ spiral (1 % 1)

-- myLayoutHook = avoidStruts $ tallLayout ||| wideLayout ||| singleLayout ||| circleLayout
--                ||| mosaicLayout ||| gridLayout ||| spiralLayout


myManageHook = composeAll
    [ className =? "Chromium"       --> doShift "2:web"
    , className =? "Google-chrome"  --> doShift "2:web"
    , resource  =? "desktop_window" --> doIgnore
    , className =? "Galculator"     --> doFloat
    , className =? "Steam"          --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "gpicview"       --> doFloat
    , className =? "MPlayer"        --> doFloat
    , className =? "VirtualBox"     --> doShift "4:vm"
    , className =? "Xchat"          --> doShift "5:media"
    , className =? "stalonetray"    --> doIgnore
    , isFullscreen --> (doF W.focusDown <+> doFullFloat)]


-- Main config.
myConfig = defaultConfig {
    modMask = myModMask
  , terminal           = myTerminal
  , focusFollowsMouse  = True
  , workspaces         = myWorkSpaces
  -- , layoutHook         = myLayoutHook
  , layoutHook = smartBorders $
                       avoidStruts $
                       --smartSpacing 4 $
                       Mirror (Tall 1 (3/100) (1/2))
                       ||| Tall 1 (3/100) (1/2)
                       ||| Full
  , manageHook         = manageHook defaultConfig <+> manageDocks  <+> myManageHook
  , normalBorderColor  = "#2a2b2f"
  , focusedBorderColor = "DarkOrange"
  , borderWidth        = 2
  , startupHook = myStartupHook


  } `additionalKeysP`
        [ ("<XF86AudioRaiseVolume>", spawn "amixer -D pulse sset Master 5%+")   -- volume up
        , ("<XF86AudioLowerVolume>", spawn "amixer -D pulse sset Master 5%-") -- volume down
        , ("<XF86AudioMute>"       , spawn "amixer -D pulse sset Master toggle") -- mute
                , ("<XF86AudioMute>"       , spawn "amixer -D pulse sset Master toggle") -- mute
        , ( "<XF86AudioPlay>"
          , spawn $
            unwords
                [ "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify"
                , "/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause"
                ])
        , ( "<XF86AudioNext>"
          , spawn $
            unwords
                [ "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify"
                , "/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next"
                ])
        , ( "<XF86AudioPrevious>"
          , spawn $
            unwords
                [ "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify"
                , "/org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous"
                ])
        ]
   `additionalKeys`
        [ ((controlMask .|. altMask, xK_l), spawn "xsecurelock || slock")                             -- lock screen
        , ((controlMask, xK_Print)        , spawn "sleep 0.2; scrot -s -e 'mv $f ~/Pictures/")               -- screenshot
        , ((0, xK_Print)                  , spawn "scrot -e 'mv $f ~/Pictures/'")                             -- screenshot
        , ((mod4Mask, xK_o)               , spawn "dmenu_run")                         -- dmenu
        , ((altMask, xK_Shift_L)          , spawn "/home/mikefaille/bin/layout-switch.sh") -- change layout
        , ((mod4Mask, xK_Left  ), prevWS)
        , ((mod4Mask, xK_Right ), nextWS)
        -- , ((modMask .|. controlMask .|. shiftMask, xK_space), rescreen)
        , (( mod4Mask .|. controlMask .|. shiftMask, xK_space), rescreen)
        , ((mod4Mask, xK_s), spawnSelected defaultGSConfig ["xterm","gmplayer","gvim"])
        -- , ("M1-<Tab>"   , cycleRecentWindows [xK_Alt_L] xK_Tab xK_Tab ) -- classic alt-tab behaviour
        ]
