------------------------------------------------------------------------
--                                                                    --
--              \ \/ /  \/  | ___  _ __   __ _  __| |                 --
--               \  /| |\/| |/ _ \| '_ \ / _` |/ _` |                 --
--               /  \| |  | | (_) | | | | (_| | (_| |                 --
--              /_/\_\_|  |_|\___/|_| |_|\__,_|\__,_|                 --
--                                                                    --
--                          XMonad 0.17.1                             --
------------------------------------------------------------------------
-- Bruno Hoffmann                                                     --
-- https://github.com/Robotix-00                                      --
------------------------------------------------------------------------
---TODOs-------------------------------------------------------------{{{
-- [~] - add more and better layouts
-- [~] - add usefull scratchpads
-- [ ] - add colorizer to gridselect
-- [ ] - Add resize to windows
-- [ ] - add more colors?
-- [~] - add filter function to application (not sure if possible)
---------------------------------------------------------------------}}}
---modules-----------------------------------------------------------{{{
import Data.Monoid
import Data.Tree
import Data.Maybe
import System.Exit
import System.Directory
import XMonad
import System.IO

import XMonad.Actions.DynamicProjects
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.GridSelect
import XMonad.Actions.SpawnOn
import XMonad.Actions.Navigation2D

import XMonad.Config
import XMonad.ManageHook

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks           -- avoid xmobar
import XMonad.Hooks.SetWMName             -- for fixing java gui applications
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.StatusBar
import XMonad.Hooks.WorkspaceHistory

import XMonad.Layout.Circle
import qualified XMonad.Layout.GridVariants as GV
import XMonad.Layout.NoFrillsDecoration(noFrillsDeco)
import XMonad.Layout.Renamed
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.Layout.ThreeColumns
import XMonad.Layout.PerScreen

import XMonad.Util.EZConfig(mkNamedKeymap)    -- for a better keymap layout
import XMonad.Util.NamedActions(NamedAction, (^++^), showKm, addName, noName, addDescrKeys', subtitle)
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad

import qualified Data.Map        as M
import qualified XMonad.Actions.TreeSelect as TS
import qualified XMonad.Layout.BoringWindows as BW
import qualified XMonad.StackSet as W

---------------------------------------------------------------------}}}
---constants---------------------------------------------------------{{{
myTerminal  = "kitty"
myBrowser = "firefox"
myStatusbar = "xmobar -x0 $HOME/.config/xmonad/xmobar/xmobar.hs"
myMenu    = "ulauncher"
myFont    = "xft:FiraCode-16"


myApplications :: [(String, String, String)]
myApplications =
  -- filter(\(_, command, _) -> isNothing $ findExecutable command) --TODO: findExecutable returns IO action, see https://stackoverflow.com/questions/23094932/how-to-use-io-string-function-in-xmonad-key-bindings
  [ ("Alacritty", "alacritty", "gpu-based terminal emulator")
  , ("Kitty", "kitty", "another gpu-based terminal emulator")
  , ("Vim", myTerminal ++ " -e vim", "text editor")
  , ("VS Code", "code", "light weight code editor")
  , ("Firefox", "firefox", "nice browser")
  , ("Brave", "brave", "privacy browser")
  , ("Thunderbird", "thunderbird", "graphical email client")
  , ("Evince", "evince", "pdf viewer")
  , ("VLC-Player", "vlc", "media player")
  , ("Spotify", "spotify", "music goes brrr")
  , ("Discord", "discord", "discord")
  , ("LibreOffice", "libreoffice", "writing and stuff")
  , ("Gimp", "gimp", "painting'n'shit")
  , ("Joplin", "joplin-desktop", "Notes")
  ]

---------------------------------------------------------------------}}}
---main--------------------------------------------------------------{{{
main = do
  -- trying to fix hibernation problems by having that here
  spawn "xrandr --output HDMI-0 --primary --mode 1920x1080 --pos 1080x840 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate left --output DP-0 --off --output DP-1 --off"

  xmonad
    . withNavigation2DConfig myNav2DConf
    . dynamicProjects projects
    . addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys' --TODO use different displayer than xMessage
    . withSB mySB
    . ewmh
    . docks
    $ myConfig

-- Display keyboard mappings using zenity
-- from https://github.com/thomasf/dotfiles-thomasf-xmonad/
--              blob/master/.xmonad/lib/XMonad/Config/A00001.hs
showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
    h <- spawnPipe "zenity --text-info --font=terminus"
    hPutStr h (unlines $ showKm x)
    hClose h
    return ()

-- config
myConfig = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = False,
        clickJustFocuses   = True,
        borderWidth        = 0,
        modMask            = mod4Mask,
        -- workspaces         = myWorkspaces,
        workspaces = TS.toWorkspaces myTreeSpaces,

      -- key bindings
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = workspaceHistoryHook,
        startupHook        = myStartupHook
                 }

---------------------------------------------------------------------}}}
---configs-----------------------------------------------------------{{{
color_base1   = "#133b45"
color_base2   = "#1e5c6c"
color_base3   = "#297f94"
color_active  = "#268bd2"
color_backg   = "#1b2b34"
color_foreg   = color_active

topbar        = 10


myTabConfig = def
  { activeBorderColor = color_base3
  , inactiveBorderColor = color_base1
  , activeColor = color_base1
  , inactiveColor = color_base3
  }

topBarTheme = def
  { fontName              = myFont
  , inactiveBorderColor   = color_base3
  , inactiveColor         = color_base3
  , inactiveTextColor     = color_base3
  , activeBorderColor     = color_active
  , activeColor           = color_active
  , activeTextColor       = color_active
  , urgentBorderColor     = "#FF0000" --TODO
  , urgentTextColor       = "#FFFF00" --TODO
  , decoHeight            = topbar
  }


myNav2DConf = def
    { defaultTiledNavigation    = centerNavigation
    , floatNavigation           = centerNavigation
    , screenNavigation          = lineNavigation
    , layoutNavigation          = [("Full",          centerNavigation)
    -- line/center same results   ,("Simple Tabs", lineNavigation)
    --                            ,("Simple Tabs", centerNavigation)
                                  ]
    , unmappedWindowRect        = [("Full", singleWindowRect)
    -- works but breaks tab deco  ,("Simple Tabs", singleWindowRect)
    -- doesn't work but deco ok   ,("Simple Tabs", fullScreenRect)
                                  ]
    }


---------------------------------------------------------------------}}}
---workspaces--------------------------------------------------------{{{

wsGEN = "gen"
wsDEV = "dev"
wsWEB = "web"
wsENT = "media"

-- TODO: fix shortcut navigation (add dynamic workspaces)
myTreeSpaces :: Forest String
myTreeSpaces = [ Node wsGEN []
               , Node wsWEB []
               , Node wsDEV
                 -- [ Node "Browser" []
                 -- ]
               , Node "four" []
               , Node "five" []
               , Node "six" []
               , Node "seven" []
               , Node "eight" []
               , Node "nine" []
               ]

projects :: [Project]
projects = [ Project { projectName  = wsGEN
  , projectDirectory = "~/"
  , projectStartHook = Nothing
                     }
  , Project { projectName  = wsDEV
  , projectDirectory = "~/"
  , projectStartHook = Just $ do spawnOn wsDEV myTerminal
            }
  , Project { projectName  = wsWEB
  , projectDirectory = "~/"
  , projectStartHook = Just $ do spawnOn wsWEB myBrowser
                                 }
           ]
---------------------------------------------------------------------}}}
---interface---------------------------------------------------------{{{
---statusbar---------------------------------------------------------{{{
mySB = statusBarProp myStatusbar (pure myPP)

myPP = filterOutWsPP [ "NSP" ] def
        { ppCurrent             = xmobarColor color_active "" . wrap "[" "]"
        , ppVisible             = xmobarColor color_base3  "" . wrap "(" ")"
        , ppHidden              = xmobarColor color_base3  "" . wrap "{" "}"
        , ppUrgent              = xmobarColor "#FF0000"    "" . wrap "!" "!"    --TODO
        , ppTitle               = xmobarColor color_active "" . shorten 30
        , ppLayout              = xmobarColor "#00FFFF" ""
        , ppTitleSanitize       = xmobarStrip
        , ppWsSep               = " "
        , ppOrder               = id
        }
---------------------------------------------------------------------}}}
---gridselect--------------------------------------------------------{{{

remap' :: [(String, String, String)] -> [(String, String)]
remap' = map (\(a,b,c)->(a,b))

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect myGridConfig lst >>= flip whenJust spawn

myGridConfig = def
      { gs_cellheight = 40
      , gs_cellwidth = 200
      , gs_cellpadding = 6
      , gs_originFractX = 0.5
      , gs_originFractY = 0.5
      , gs_font = myFont
      }

-- TODO: get this to work
myGridColorizer :: Window -> Bool -> X (String, String)
myGridColorizer = colorRangeFromClassName
                     black            -- lowest inactive bg
                     (0x70,0xFF,0x70) -- highest inactive bg
                     black            -- active bg
                     white            -- inactive fg
                     white            -- active fg
  where black = minBound-- 0x297f94
        white = maxBound-- 0x133b45
---------------------------------------------------------------------}}}
---treeselect--------------------------------------------------------{{{
treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
   [ Node (TS.TSNode "Power" "Shutdown, etc." (spawn "systemctl hibernate"))
           [ Node (TS.TSNode "Reboot"   "Reboots the system"  (spawn "poweroff --reboot")) []
           , Node (TS.TSNode "Poweroff"   "Shuts down the system"  (spawn "poweroff")) []
           , Node (TS.TSNode "Lock screen" "Locks the screen" (spawn "xscreensaver-command -lock")) []
           , Node (TS.TSNode "Suspend" "Suspends the system" (spawn "systemctl suspend")) []
           , Node (TS.TSNode "Hibernate" "Puts the system inti hibernation" (spawn "systemctl hibernate")) []
           ]
   , Node (TS.TSNode "Applications" "My Applications" (return ())) treeApplications
   , Node (TS.TSNode "NixOS Utility" "utility commands to manage nixos" (return ()))
          [ Node (TS.TSNode "update" "update nixos system" (spawn "kitty --hold sudo nixos-rebuild switch --flake $DOTFILES")) []
          , Node (TS.TSNode "cleanup/optimize" "delete old generations & optimize store" (spawn "kitty --hold sudo nix-collect-garbage -d && nix store optimise")) []
          -- , Node (TS.TSNode "" "" ()) []
          -- , Node (TS.TSNode "" "" ()) []
          ]
   ]
   where
     treeApplications = map (\(a, b, c) -> Node (TS.TSNode a c (spawn b)) []) myApplications


tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
  , TS.ts_background   = 0xdd1b2b34
  , TS.ts_font         = myFont
  , TS.ts_node         = (0xFF237f94, 0xFF1e5c6c)
  , TS.ts_nodealt      = (0xFF237f94, 0xFF133b45)
  , TS.ts_highlight    = (0xffffffff, 0xFF268bd2)
  , TS.ts_extra        = 0xffd0d0d0
  , TS.ts_node_width   = 200
  , TS.ts_node_height  = 30
  , TS.ts_originX      = 20
  , TS.ts_originY      = 20
  , TS.ts_indent       = 80
  , TS.ts_navigate     = myTreeNavigation
                              }


myTreeNavigation = M.fromList
    [ ((0, xK_Escape), TS.cancel)
      , ((0, xK_Return), TS.select)
      , ((0, xK_space),  TS.select)
      , ((0, xK_Up),     TS.movePrev)
      , ((0, xK_Down),   TS.moveNext)
      , ((0, xK_Left),   TS.moveParent)
      , ((0, xK_Right),  TS.moveChild)
      , ((0, xK_k),      TS.movePrev)
      , ((0, xK_j),      TS.moveNext)
      , ((0, xK_h),      TS.moveParent)
      , ((0, xK_l),      TS.moveChild)
      , ((0, xK_o),      TS.moveHistBack)
      , ((0, xK_i),      TS.moveHistForward)
    ]
---------------------------------------------------------------------}}}
---scratchpads-------------------------------------------------------{{{
scratchpads = [ NS "spotify" "spotify" (className =? "Spotify") defaultFloating
              , NS "discord" "discord" (className =? "discord") defaultFloating
              , NS "bluetooth" "blueman-manager" (className =? ".blueman-manager-wrapped") defaultFloating
              ]
---------------------------------------------------------------------}}}
---------------------------------------------------------------------}}}
---layouts-----------------------------------------------------------{{{
myLayout = avoidStruts $ windowNavigation $ BW.boringWindows
  (main ||| Full)
  where
    named n        = renamed [XMonad.Layout.Renamed.Replace n]

    addTopBar      = noFrillsDeco shrinkText topBarTheme

    mySpacing      = spacing 5
    tabbs          = addTabs shrinkText myTabConfig

    main = named "Default" $
            addTopBar $
            tabbs $
            subLayout [] (Simplest ||| Circle) $
            mySpacing $
                ifWider 1080 big small
      where
        big = ThreeColMid 1 (3/100) (1/2)
        -- small = Mirror big

        small = Mirror (GV.TallGrid 1 1 (1/2) 1 (3/100))

    -- tall = named "Tall" $
    --   addTopBar $
    --     tabbs $ sublayouts $
    --       mySpacing $
    --         Tall 1 (3/100) (1/2)

---------------------------------------------------------------------}}}
---hooks-------------------------------------------------------------{{{

-- event hook
myEventHook = dynamicPropertyChange "WM_NAME" (className =? "Spotify" --> floating)
          <+> swallowEventHookSub (className =? "Alacritty" <||> className =? "kitty") (return True)
  where
    floating = customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)

-- startup hook
myStartupHook = do
  spawn "xsetroot -cursor_name left_ptr"
  setWMName "LG3D"                        -- for java applications work
  spawn "setxkbmap -layout de"            -- keyboard layout
  spawn "refresh-background"          -- background

myManageHook = manageAll <+> namedScratchpadManageHook scratchpads
  where
  manageAll = composeAll
      [ className =? "MPlayer"        --> doFloat
      -- , className =? "Soffice"        --> doFloat
      , resource  =? "desktop_window" --> doIgnore
      , resource  =? "kdesktop"       --> doIgnore ]

---------------------------------------------------------------------}}}
---keybindings-------------------------------------------------------{{{
myKeys' conf =
  subKeys "System"
  [ ("M-q"            , addName "Restart XMonad"      $ spawn "xmonad --recompile; xmonad --restart")
  , ("M-C-q"          , addName "Quits XMonad"        $ io exitSuccess)
  , ("M-S-q"          , addName "Locks Screen"        $ spawn "xdg-screensaver lock")
  ] ^++^

  subKeys "Layout"
  [ ("M-<Space>"      , addName "switch layout"       $ sendMessage NextLayout)
  , ("M-S-<Space>"    , addName "reset to default layout" $ setLayout $ XMonad.layoutHook conf)
  , ("M-C-+"          , addName "increase master count" $ sendMessage (IncMasterN 1))
  , ("M-C--"          , addName "decrease master count" $ sendMessage (IncMasterN (-1)))
  ] ^++^


  subKeys "Actions"
  [ ("M-S-<Return>"   , addName "spawn terminal"      $ spawn (XMonad.terminal conf))
  , ("M-f"            , addName "spawns browser"      $ spawn myBrowser)
  , ("<Print>"      , addName "open screenshot menu"  $ spawn "flameshot gui")
  , ("M-<Backspace>"  , addName "kill selected window"$ kill)
  ] ^++^

  subKeys "Navigation"
  ([ ("M-<Tab>"        , addName "cycle windows"       $ BW.focusDown)
   , ("M-m"            , addName "return to master"    $ windows W.focusMaster)
   , ("M-<Return>"     , addName "swap master"         $ windows W.swapMaster)
   , ("M-t"            , addName "unfloats window"     $ withFocused $ windows . W.sink)
   , ("M-b"            , addName "Toggles top bar"     $ sendMessage ToggleStruts)
   , ("M-z"            , addName "workspace treeselect"$ TS.treeselectWorkspace tsDefaultConfig myTreeSpaces W.greedyView)
   ]
    ++ zipM     "M-"         "switch to ws"  wsKeys [0..] (withNthWorkspace W.greedyView)
    ++ zipM     "M-S-"       "move w to ws"  wsKeys [0..] (withNthWorkspace W.shift)
    ++ zipDir'  "M-S-"       "swap w"            windowSwap False
    ++ zipDir'  "M-"         "focus w"           windowGo False

    ++ zipWith(\k v -> ("M-"++k, addName "switch focused screen" $ (screenWorkspace v >>= flip whenJust (windows . W.view)))) screenKeys [0..]
  )^++^

  subKeys "Sub Layouts"
  ([  ("M-s m"       , addName "merge all windows"   $ withFocused (sendMessage . MergeAll))
    , ("M-s u"       , addName "seperate group"      $ withFocused (sendMessage . UnMerge))
    , ("M-s <Space>" , addName "switch sublayout"    $ toSubl NextLayout)
    , ("M-,"         , addName "Focus up in sublayout"   $ onGroup W.focusUp')
    , ("M-."         , addName "Focus down in sublayout" $ onGroup W.focusDown')
   ]
    ++ zipDir   "M-s "     "Merge w/sublayout"          (sendMessage . pullGroup)
  ) ^++^

  subKeys "Launcher"
  ([  ("M-a j"          , addName "launch tree select"  $ treeselectAction tsDefaultConfig)
    , ("M-a k"          , addName "launch grid select"  $ spawnSelected' (remap' myApplications))
    , ("M-p"            , addName "launch application application menu"        $ spawn myMenu)
   ] ++ zipWith(\k v -> ("M-s "++k, addName ("Open scratchpad <"++v++">") $ namedScratchpadAction scratchpads v)) scratchpadKeys scratchpadNames
  ) ^++^

  subKeys "media control"
  [ ("<XF86AudioRaiseVolume>", addName "raise volume" $ spawn "amixer set Master 10%+")
  , ("<XF86AudioLowerVolume>", addName "lower volume" $ spawn "amixer set Master 10%-")
  , ("<XF86AudioMute>", addName "mute volume" $ spawn "amixer set Master 1+ toggle")
  , ("<XF86AudioPlay>", addName "play audio" $ spawn "playerctl play-pause")
  , ("<XF86AudioNext>", addName "next song" $ spawn "playerctl next")
  , ("<XF86AudioPrev>", addName "prev song" $ spawn "playerctl previous")
  ]
  where
    dirKeys   = ["j", "k", "h", "l"]
    arrowKeys = ["<D>", "<U>", "<L>", "<R>"]
    dirs      = [ D, U, L, R ]

    screenKeys    = ["w", "e", "r"]
    wsKeys        = map show $ [1..9] ++ [0]
    modm          = mod4Mask

    scratchpadNames   = ["spotify", "bluetooth", "discord"]
    scratchpadKeys    = ["s", "b", "d"]

    -- wrapper function to create a named keymap
    subKeys str ks = subtitle str : mkNamedKeymap conf ks

    -- funcion applying action/direction keys to each input
    zipM  m nm ks as f = zipWith(\k v -> (m++k, addName nm $ f v)) ks as
    zipDir m nm f = zipM m nm dirKeys dirs f ++ zipM m nm arrowKeys dirs f

    zipM'  m nm ks as f b = zipWith(\k v -> (m++k, addName nm $ f v b)) ks as
    zipDir' m nm f b = zipM' m nm dirKeys dirs f b ++ zipM' m nm arrowKeys dirs f b


---Mouse bindings----------------------------------------------------{{{
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
  [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
  ]

---------------------------------------------------------------------}}}
---------------------------------------------------------------------}}}

