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

import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
-- import XMonad.Layout.Fullscreen
-- import qualified XMonad.Layout.Fullscreen as FS
import XMonad.Hooks.ManageHelpers

-- import XMonad.Actions.CycleWindows


-- let response = "killall compton; compton -CG  --backend glx --glx-use-copysubbuffermesa --glx-use-gpushader4 -d " ++ (putStrLn  =<< getEnv "DISPLAY")
--     putStrLn response

myStartupHook = setWMName "LG3D"
                >> spawnHere "killall stalonetray; stalonetray"
                >> spawn "killall compton; compton -CG  backend glx"
                >> spawn "setxkbmap ca multi"
                --glx-use-copysubbuffermesa --glx-use-gpushader4 -d " ++ (putStrLn  =<< getEnv "DISPLAY")

                -- >> spawnHere "killall nm-applet; nm-applet"
                -- >> spawnHere "killall pasystray; pasystray"

                -- >> spawnHere "feh --bg-scale $HOME/.xmonad/background.png"
                -- >> spawnHere "xcompmgr"
                -- >> spawnHere "python $HOME/bin/dropbox.py start"
                -- >> spawnHere "$HOME/.xmonad/passbackups.sh"
                -- >> spawnHere "$HOME/.xmonad/keymappings.sh"
                -- >> spawnHere "sleep 15; $HOME/.xmonad/brightness.sh"
--                 >> spawnOn nine nvidiaMenu
--                 >> spawnOn four myMusic
-- --                >> spawnOn four myIm
--                 >> spawnOn three myTerminal
-- --                >> spawnOn two myEditorInit
--                 >> spawnOn one myInternet

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

myTerminal = "export TERM=xterm; urxvt"

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
  , manageHook         = manageHook defaultConfig <+> manageDocks  <+> myManageHook
  , normalBorderColor  = "#2a2b2f"
  , focusedBorderColor = "DarkOrange"
  , borderWidth        = 1
  , startupHook = myStartupHook


  } `additionalKeysP`
        [ ("<XF86AudioRaiseVolume>", spawn "/home/mikefaille/bin/volume_level.sh up")   -- volume up
        , ("<XF86AudioLowerVolume>", spawn "/home/mikefaille/bin/volume_level.sh down") -- volume down
        , ("<XF86AudioMute>"       , spawn "/home/mikefaille/bin/volume_level.sh mute") -- mute
        ]
   `additionalKeys`
        [ ((controlMask .|. altMask, xK_l), spawn "xlock")                             -- lock screen
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
