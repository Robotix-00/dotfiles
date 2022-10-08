-- TODOs
---------------------------------------------------------------------{{{
-- [ ] - make swallowing work
-- [ ] - add more and better layouts
-- [ ] - workspace swaping/dynamic workspaces: https://xmonad.github.io/xmonad-docs/xmonad-contrib/XMonad-Actions-WorkspaceNames.html
-- [ ] - tree menu for actions
-- [x] - gridselect for applications
---------------------------------------------------------------------}}}

-- modules
---------------------------------------------------------------------{{{
import XMonad
import Data.Monoid
import System.Exit

import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Config

import XMonad.Actions.DynamicProjects
import XMonad.Actions.SpawnOn
import XMonad.Actions.GridSelect
import qualified XMonad.Actions.TreeSelect as TS

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.WindowSwallowing

import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Fullscreen (fullscreenFull, fullscreenSupport)
import XMonad.Layout.Grid (Grid(..))

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Tree
---------------------------------------------------------------------}}}

-- constants & settings
---------------------------------------------------------------------{{{
myTerminal	= "alacritty"
myBrowser	= "firefox"
myStatusbar	= "xmobar -x0 $HOME/.config/xmonad/xmobarrc"
myMenu		= "dmenu_run"
myFont		= "xft:FiraCode-16"

myApplications :: [(String, String, String)]
myApplications = [ ("Alacritty", "alacritty", "gpu-based terminal emulator")
                 , ("Firefox", "firefox", "nice browser")
                 , ("Thunderbird", "thunderbird", "graphical email client")
                 , ("Spotify", "spotify", "music goes brrr")
		 , ("Discord", "discord", "discord")
		 , ("LibreOffice", "libreoffice", "writing and stuff")
		 ]
---------------------------------------------------------------------}}}

-- main & config
---------------------------------------------------------------------{{{
main = do
  xmproc <- spawnPipe myStatusbar

  xmonad
    $ docks
    $ dynamicProjects projects
    $ myConfig xmproc

-- config
myConfig p = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = False,
        clickJustFocuses   = True,
        borderWidth        = 1,
        modMask            = mod4Mask,
        workspaces         = myWorkspaces, 
        normalBorderColor  = "#000000",
        focusedBorderColor = "#268bd2",

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook p,
        startupHook        = myStartupHook
    }

---------------------------------------------------------------------}}}

-- workspaces
---------------------------------------------------------------------{{{

wsGEN = "gen"
wsDEV = "dev"
wsWEB = "web"
wsENT = "media"
wsCOM = "com"

myWorkspaces = [ wsGEN, wsWEB, wsDEV, wsENT, wsCOM, "six", "seven", "eight", "nine"]

projects :: [Project]
projects = [ Project { projectName	= wsGEN
                     , projectDirectory	= "~/"
	  	     , projectStartHook	= Nothing
	  	     }
	   , Project { projectName	= wsDEV
	   	     , projectDirectory = "~/"
		     , projectStartHook = Just $ do spawnOn wsDEV myTerminal
		     				    spawnOn wsDEV myTerminal
		     }
	   , Project { projectName	= wsWEB
	   	     , projectDirectory	= "~/"
		     , projectStartHook	= Just $ do spawnOn wsWEB myBrowser
		     }
	   , Project { projectName	= wsENT
	   	     , projectDirectory	= "~/"
		     , projectStartHook	= Just $ do spawnOn wsENT "spotify"
		     }
	   , Project { projectName	= wsCOM
		     , projectDirectory	= "~/"
		     , projectStartHook	= Just $ spawnOn wsCOM	"discord"
		     }
  ]

-- gridselect stuff
myAppGrid :: [(String, String)]
myAppGrid = [ ("Alacritty", "alacritty")
            , ("Firefox", "firefox")
	    , ("ThunderBird", "thunderbird")
	    , ("Spotify", "spotify")
	    , ("Discord", "discord")
	    , ("LibreOffice", "libreoffice")
	    ]

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
    where conf = def
                   { gs_cellheight   = 40
                   , gs_cellwidth    = 200
                   , gs_cellpadding  = 6
                   , gs_originFractX = 0.5
                   , gs_originFractY = 0.5
		   , gs_font         = myFont
                   }


-- treeselect stuff
treeselectAction :: TS.TSConfig (X ()) -> X ()
treeselectAction a = TS.treeselectAction a
   [ Node (TS.TSNode "Power" "Shutdown, etc." (spawn "shutdown 0"))
           [ Node (TS.TSNode "Reboot"   "Reboots the system"  (spawn "reboot")) []
           , Node (TS.TSNode "Suspend" "Suspends the system" (spawn "systemctl suspend")) []
           , Node (TS.TSNode "Hibernate" "Puts the system inti hibernation" (spawn "systemctl hibernate")) []
	   ]
   , Node (TS.TSNode "NixOS Utility" "work in progress" (return ())) []
   , Node (TS.TSNode "Applications" "" (return ())) []
   ]
tsDefaultConfig :: TS.TSConfig a
tsDefaultConfig = TS.TSConfig { TS.ts_hidechildren = True
                              , TS.ts_background   = 0xdd292d3e
                              , TS.ts_font         = myFont
                              , TS.ts_node         = (0xffd0d0d1, 0xff202331)
                              , TS.ts_nodealt      = (0xffd0d0d0, 0xff292d3e)
                              , TS.ts_highlight    = (0xffffffff, 0xff755999)
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

-- my layouts
---------------------------------------------------------------------{{{
myLayout = avoidStruts $ windowNavigation $ subTabbed $
           -- with spacing
	   spacingWithEdge 5 (
	     tall
	     ||| Grid
	   )
	   -- without spacing
	   ||| full
	where
	  full = (noBorders Full)
	  tall = Tall 1 (3/100) (1/2)

---------------------------------------------------------------------}}}

-- hooks
---------------------------------------------------------------------{{{

-- event hook
myEventHook = swallowEventHookSub (className =? "Alacritty") (return True)


-- log hook
myLogHook h = do
  dynamicLogWithPP $ def {
    ppOutput = hPutStrLn h
  }


-- startup hook
myStartupHook = do
  spawn "xrandr --output HDMI-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-1 --mode 1920x1080 --pos 3840x0 --rotate normal --output DP-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off"
  spawn "setxkbmap -layout de"
  spawnOnce "nitrogen --restore &"

-- manage hook
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Soffice"        --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

---------------------------------------------------------------------}}}

-- Key bindings
---------------------------------------------------------------------{{{
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)	-- launch terminal
    , ((modm,		    xK_f     ), spawn myBrowser)		-- spawn firefox
    , ((modm,               xK_p     ), spawn myMenu)		-- launch dmenu
    , ((modm,		    xK_BackSpace), kill)			-- kill selected window

    , ((modm,               xK_space ), sendMessage NextLayout)		-- cycle layouts
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)	-- reset to default layout
    
    , ((modm,               xK_Tab   ), windows W.focusDown)		-- next window/cycle
    , ((modm,               xK_j     ), windows W.focusDown)		-- next window
    , ((modm,               xK_k     ), windows W.focusUp  )		-- previrous window

    , ((modm,               xK_m     ), windows W.focusMaster)		-- return focus back to master
    , ((modm,               xK_Return), windows W.swapMaster)		-- swap focused and master window

    -- sublayout test
    , ((modm .|. controlMask, xK_h), sendMessage $ pullGroup L)
    , ((modm .|. controlMask, xK_l), sendMessage $ pullGroup R)
    , ((modm .|. controlMask, xK_k), sendMessage $ pullGroup U)
    , ((modm .|. controlMask, xK_j), sendMessage $ pullGroup D)

    , ((modm .|. controlMask, xK_m), withFocused (sendMessage . MergeAll))
    , ((modm .|. controlMask, xK_u), withFocused (sendMessage . UnMerge))

    , ((modm .|. controlMask, xK_period), onGroup W.focusUp')
    , ((modm .|. controlMask, xK_comma), onGroup W.focusDown')
    
    -- gridselect
    , ((modm, xK_s), spawnSelected' myAppGrid)

    -- treeselect
    , ((modm,               xK_a     ), treeselectAction tsDefaultConfig)
    
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)	-- push window back into tiling
    , ((modm              , xK_b     ), sendMessage ToggleStruts)	-- toggle top bar spacing
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))	-- quit xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")	-- restart xmonad
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]

---------------------------------------------------------------------}}}

