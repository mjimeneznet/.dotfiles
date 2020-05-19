import XMonad
import XMonad.Config.Desktop
import Data.List
import qualified Data.Map as M
import Data.Monoid
import System.Exit
import System.IO                            -- for xmonbar

import XMonad.Actions.SpawnOn
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.EZConfig
import qualified XMonad.StackSet as W
import XMonad.Util.NamedScratchpad
import XMonad.ManageHook

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName -- Sets the WM name to a given string (fix Java things)
import XMonad.Util.SpawnOnce -- Spawns a command once, and only once
import XMonad.Util.Cursor -- Sets the default mouse cursor
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle)) -- Toggle between Layouts
import XMonad.Actions.MouseResize -- Resize Windows with the mouse (lower right corner)
import XMonad.Layout.MultiToggle  -- Apply and unapply transformers to window layout (rotate, zoom in, zoom out)
import XMonad.Layout.MultiToggle.Instances  -- Common instances for the previous module
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))  -- move and resize windows with the keyboard in any layout
import XMonad.Layout.SimplestFloat -- basic floating layout like SimpleFloat but without the decoration
import XMonad.Layout.OneBig -- one (master) window at top left corner of screen, and other (slave) windows at top
import XMonad.Layout.ThreeColumns  -- With 2560x1600 pixels this layout can be used for a huge main window and up to six reasonable sized slave windows
import XMonad.Layout.Renamed (renamed, Rename(CutWordsLeft, Replace)) -- Layout modifier that can modify the description of its underlying layout
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit) -- Layout modifier that limits the number of windows that can be shown
import XMonad.Layout.ResizableTile -- More useful tiled layout that allows you to change a width/height of window.
import XMonad.Layout.ZoomRow (zoomRow, zoomIn, zoomOut, zoomReset, ZoomMessage(ZoomFullToggle)) -- Row layout with individually resizable elements
import XMonad.Layout.Reflect (reflectVert, reflectHoriz, REFLECTX(..), REFLECTY(..)) -- Reflect a layout horizontally or vertically
import XMonad.Layout.GridVariants (Grid(Grid))  -- Two layouts: one is a variant of the Grid layout that allows the desired aspect ratio of windows to be specified. The other is like Tall but places a grid with fixed number of rows and columns in the master area and uses an aspect-ratio-specified layout for the slaves
import XMonad.Hooks.EwmhDesktops -- Makes xmonad use the EWMH hints to tell panel applications about its workspaces and the windows therein. It also allows the user to interact with xmonad by clicking on panels and window lists
import XMonad.Hooks.DynamicProperty --apply a ManageHook to an already-mapped window when a property changes
import XMonad.Layout.Fullscreen as LF
import XMonad.Hooks.ManageHelpers -- Helper functions to be used in manageHook
import XMonad.Hooks.FadeWindows -- flexible and general compositing interface than FadeInactive
import XMonad.Util.NamedActions -- A wrapper for keybinding configuration that can list the available keybindings
import XMonad.Util.Paste as P -- A module for sending key presses to windows
import qualified XMonad.Actions.ConstrainedResize as Sqr -- Lets you constrain the aspect ratio of a floating window
import XMonad.Prompt                        -- A module for writing graphical prompts for XMonad 
import XMonad.Prompt.ConfirmPrompt          -- A module for setting up simple confirmation prompts for keybindings
import Control.Monad (liftM, liftM2, join)  -- myManageHookShift
import XMonad.Actions.CycleWS -- Provides bindings to cycle forward or backward through the list of workspaces
import XMonad.Util.WorkspaceCompare -- custom WS functions filtering NSP
import XMonad.Actions.MessageFeedback       -- pseudo conditional key bindings
import XMonad.Layout.BinarySpacePartition -- Layout where new windows will split the focused window in half, based off of BSPWM
import XMonad.Actions.SinkAll -- pushes all floating windows on the current workspace back into tiling
import XMonad.Util.XSelection -- accessing and manipulating X Window's mouse selection
import XMonad.Actions.CopyWindow -- Provides bindings to duplicate a window on multiple workspaces
import XMonad.Actions.FloatSnap -- Move and resize floating windows using other windows and the edge of the screen as guidelines
import XMonad.Hooks.UrgencyHook -- UrgencyHook lets you configure an action to occur when a window demands your attention
import XMonad.Util.NamedWindows -- This module allows you to associate the X titles of windows with them
import XMonad.Actions.WithAll -- Functions for performing action on all windows of the current workspace
import XMonad.Actions.Promote -- Promote windows to master

---------------------------------------------------------------------
--CONFIG
---------------------------------------------------------------------
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myTerminal           = "alacritty"

rofiAppCommand       = "rofi -show run"

spotifyCommand       = "spotify"
spotifyClassName     = "Spotify"
isSpotify            = (className =? spotifyClassName)

slackCommand         = "slack"
slackClassName       = "Slack"
isSlack              = (className =? slackClassName)

pavucontrolCommand   = "pavucontrol"
pavucontrolClassName = "pavucontrol"
isPavucontrol        = (className =? pavucontrolClassName)
---------------------------------------------------------------------
--THEME
---------------------------------------------------------------------
myFont = "xft:FiraCode Nerd Font:regular:pixelsize=12"  
myBorderWidth = 2
myBorderNormalColor = "#292d3e"
myBorderFocusedColor = "#bbc5ff"

myPromptTheme = def
    { font                  = myFont
    , bgColor               = "#002b36"
    , fgColor               = "#268bd2"
    , fgHLight              = "#002b36"
    , bgHLight              = "#268bd2"
    , borderColor           = "#002b36"
    , promptBorderWidth     = 0
    , height                = 20
    , position              = Top
    }

hotPromptTheme = myPromptTheme
    { bgColor               = "#dc322f"
    , fgColor               = "#fdf6e3"
    , position              = Top
    }

---------------------------------------------------------------------
--WORKSPACES
---------------------------------------------------------------------
wsDEV  = "1:dev"
wsCOM  = "2:com"
wsWWW  = "3:www"
wsVIRT = "4:virt"
wsGFX  = "5:GFX"

myWorkspaces = [wsDEV, wsCOM, wsWWW, wsVIRT, wsGFX]

---------------------------------------------------------------------
--SCRATCHPADS
---------------------------------------------------------------------
myScratchpads = [ NS "spotify" spotifyCommand isSpotify centered 
                , NS "pavucontrol" pavucontrolCommand isPavucontrol centeredSmall
                , NS "slack" slackCommand isSlack centered
              ]
              where
                role = stringProperty "WM_WINDOW_ROLE"
                centered = customFloating $ W.RationalRect 0.05 0.05 0.9 0.9
                centeredSmall = customFloating $ W.RationalRect l t w h
                  where
                    h = 0.6       -- height, 60%
                    w = 0.6       -- width, 60%
                    t = (1 - h)/2 -- centered top/bottom
                    l = (1 - w)/2 -- centered left/right


---------------------------------------------------------------------
--LAYOUTS
---------------------------------------------------------------------
myLayouts = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $ 
               mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ myDefaultLayout
             where 
                 myDefaultLayout = tall ||| grid ||| threeCol ||| threeRow ||| oneBig ||| noBorders monocle ||| space ||| floats


tall       = renamed [Replace "tall"]     $ limitWindows 12 $ spacing 6 $ ResizableTall 1 (3/100) (1/2) []
grid       = renamed [Replace "grid"]     $ limitWindows 12 $ spacing 6 $ mkToggle (single MIRROR) $ Grid (16/10)
threeCol   = renamed [Replace "threeCol"] $ limitWindows 3  $ ThreeCol 1 (3/100) (1/2) 
threeRow   = renamed [Replace "threeRow"] $ limitWindows 3  $ Mirror $ mkToggle (single MIRROR) zoomRow
oneBig     = renamed [Replace "oneBig"]   $ limitWindows 6  $ Mirror $ mkToggle (single MIRROR) $ mkToggle (single REFLECTX) $ mkToggle (single REFLECTY) $ OneBig (5/9) (8/12)
monocle    = renamed [Replace "monocle"]  $ limitWindows 20 $ Full
space      = renamed [Replace "space"]    $ limitWindows 4  $ spacing 12 $ Mirror $ mkToggle (single MIRROR) $ mkToggle (single REFLECTX) $ mkToggle (single REFLECTY) $ OneBig (2/3) (2/3)
floats     = renamed [Replace "floats"]   $ limitWindows 20 $ simplestFloat


---------------------------------------------------------------------------
-- Event Actions
---------------------------------------------------------------------------

myHandleEventHook = docksEventHook
                <+> fadeWindowsEventHook
                <+> handleEventHook def
                <+> LF.fullscreenEventHook 
                <+> spotifyForceFloatingEventHook


forceCenterFloat :: ManageHook
forceCenterFloat = doFloatDep move
  where
    move :: W.RationalRect -> W.RationalRect
    move _ = W.RationalRect x y w h

    w, h, x, y :: Rational
    w = 1/3
    h = 1/2
    x = (1-w)/2
    y = (1-h)/2


spotifyForceFloatingEventHook :: Event -> X All
spotifyForceFloatingEventHook = dynamicPropertyChange "WM_NAME" (title =? "Spotify" --> floating)
    where floating  = (customFloating $ W.RationalRect (1/40) (1/20) (19/20) (9/10))

---------------------------------------------------------------------
--STARTUP
---------------------------------------------------------------------
myStartupHook = do
          setWMName "LG3D"
          setDefaultCursor xC_left_ptr
          spawnOnce "compton --config ~/.config/compton/compton.conf" 
          spawnOnce "~/.local/bin/manage_screens.sh"
          --spawnOnce "emacs --daemon &" 
          --spawnOnce "nitrogen --restore &" 
          --spawnOnce "exec /usr/bin/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 15 --transparent true --alpha 0 --tint 0x292d3e --height 19 &"
  
quitXmonad :: X ()
quitXmonad = io (exitWith ExitSuccess)

rebuildXmonad :: X ()
rebuildXmonad = do
    spawn "xmonad --recompile && xmonad --restart"

restartXmonad :: X ()
restartXmonad = do
    spawn "monad --restart"

---------------------------------------------------------------------------
--URGENCY 
---------------------------------------------------------------------------
-- from https://pbrisbin.com/posts/using_notify_osd_for_xmonad_notifications/
data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset

        safeSpawn "notify-send" [show name, "workspace " ++ idx]
-- cf https://github.com/pjones/xmonadrc

 
---------------------------------------------------------------------
--KEYBINDINGS
---------------------------------------------------------------------
myModMask = mod4Mask -- Sets modkey to Super  

-- Display keyboard mappings using zenity
-- from https://github.com/thomasf/dotfiles-thomasf-xmonad/
--              blob/master/.xmonad/lib/XMonad/Config/A00001.hs
showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
    h <- spawnPipe "zenity --text-info --font=terminus"
    hPutStr h (unlines $ showKm x)
    hClose h
    return ()

wsKeys = map show $ [1..9] ++ [0]

-- any workspace but scratchpad
notSP = (return $ ("NSP" /=) . W.tag) :: X (WindowSpace -> Bool)
shiftAndView dir = findWorkspace getSortByIndex dir (WSIs notSP) 1
        >>= \t -> (windows . W.shift $ t) >> (windows . W.greedyView $ t)

-- hidden, non-empty workspaces less scratchpad
shiftAndView' dir = findWorkspace getSortByIndexNoSP dir HiddenNonEmptyWS 1
        >>= \t -> (windows . W.shift $ t) >> (windows . W.greedyView $ t)
nextNonEmptyWS = findWorkspace getSortByIndexNoSP Next HiddenNonEmptyWS 1
        >>= \t -> (windows . W.view $ t)
prevNonEmptyWS = findWorkspace getSortByIndexNoSP Prev HiddenNonEmptyWS 1
        >>= \t -> (windows . W.view $ t)
getSortByIndexNoSP =
        fmap (.namedScratchpadFilterOutWorkspace) getSortByIndex

-- toggle any workspace but scratchpad
myToggle = windows $ W.view =<< W.tag . head . filter
        ((\x -> x /= "NSP" && x /= "SP") . W.tag) . W.hidden

myKeys conf = let

    subKeys str ks = subtitle str : mkNamedKeymap conf ks
    screenKeys     = ["w","v","z"]
    dirKeys        = ["j","k","h","l"]
    arrowKeys      = ["<D>","<U>","<L>","<R>"]
    dirs           = [ D,  U,  L,  R ]

    --screenAction f        = screenWorkspace >=> flip whenJust (windows . f)

    zipM  m nm ks as f = zipWith (\k d -> (m ++ k, addName nm $ f d)) ks as
    zipM' m nm ks as f b = zipWith (\k d -> (m ++ k, addName nm $ f d b)) ks as

    -- from xmonad.layout.sublayouts
    focusMaster' st = let (f:fs) = W.integrate st
        in W.Stack f [] fs
    swapMaster' (W.Stack f u d) = W.Stack f [] $ reverse u ++ d

    -- try sending one message, fallback if unreceived, then refresh
    tryMsgR x y = sequence_ [(tryMessage_ x y), refresh]

    -- warpCursor = warpToWindow (9/10) (9/10)

    -- cf https://github.com/pjones/xmonadrc
    --switch :: ProjectTable -> ProjectName -> X ()
    --switch ps name = case Map.lookup name ps of
    --  Just p              -> switchProject p
    --  Nothing | null name -> return ()

    -- do something with current X selection
    unsafeWithSelection app = join $ io $ liftM unsafeSpawn $ fmap (\x -> app ++ " " ++ x) getSelection

    toggleFloat w = windows (\s -> if M.member w (W.floating s)
                    then W.sink w s
                    else (W.float w (W.RationalRect (1/3) (1/4) (1/2) (4/5)) s))

    in

    -----------------------------------------------------------------------
    -- System / Utilities
    -----------------------------------------------------------------------
    subKeys "Xmonad"
    [ ("M-q"                       , addName "Restart XMonad"                  $ confirmPrompt hotPromptTheme "Restart XMonad" $ restartXmonad)
    , ("M-C-q"                     , addName "Recompile and Restart XMonad"    $ confirmPrompt hotPromptTheme "Recompile and Restart XMonad" $ rebuildXmonad)
    , ("M-S-q"                     , addName "Quit XMonad"                     $ confirmPrompt hotPromptTheme "Quit XMonad" $ io (exitWith ExitSuccess))
    ] ^++^

    -----------------------------------------------------------------------
    -- Applications 
    -----------------------------------------------------------------------
    subKeys "Applications"
    [ ("M-<Return>"                , addName "Terminal"                        $ spawn myTerminal)
    , ("M-S-s"                       , addName "Slack"                           $ namedScratchpadAction myScratchpads "slack")
    , ("M-S-a"                       , addName "Pavucontrol"                           $ namedScratchpadAction myScratchpads "pavucontrol")
    , ("M-S-z"                       , addName "Spotify"                           $ namedScratchpadAction myScratchpads "spotify")
   
    ] ^++^
    -----------------------------------------------------------------------
    -- Launchers 
    -----------------------------------------------------------------------
    subKeys "Launchers"
    [ ("M-p"                       , addName "Rofi Apps"                       $ spawn rofiAppCommand)
    
    ] ^++^ 

    -----------------------------------------------------------------------
    -- Windows 
    -----------------------------------------------------------------------
    subKeys "Windows"
    (
    [ ("M-<Backspace>"            , addName "Kill"                            kill1)
    , ("M-S-<Backspace>"          , addName "Kill all"                        $ confirmPrompt hotPromptTheme "kill all" $ killAll)
    , ("M-d"                      , addName "Duplicate w to all ws"           $ toggleCopyToAll)
    , ("M-S-d"                    , addName "Kill other duplicates"           $ killAllOtherCopies)
    , ("M-S-p"                      , addName "Promote"                         $ promote)
    , ("M-z u"                    , addName "Focus urgent"                    focusUrgent)
    , ("M-z m"                    , addName "Focus master"                    $ windows W.focusMaster)
    ]

    -- ++ zipM' "M-"               "Navigate window"                           dirKeys dirs windowGo True
    -- ++ zipM' "M-S-"               "Move window"                               dirKeys dirs windowSwap True
  --  ++ zipM' "M1-"              "Move window"                               dirKeys dirs windowSwap True
  --  ++ zipM  "M-C-"             "Merge w/sublayout"                         dirKeys dirs (sendMessage . pullGroup)
  --  ++ zipM' "M-S-"             "Navigate screen"                           arrowKeys dirs screenGo True
  --  ++ zipM' "M-C-"             "Move window to screen"                     arrowKeys dirs windowToScreen True
 --   ++ zipM' "M-S-"             "Swap workspace to screen"                  arrowKeys dirs screenSwap True

    ) ^++^
 
    -----------------------------------------------------------------------
    -- Layouts & Sub-layouts
    -----------------------------------------------------------------------

    subKeys "Layout Management"

    [ ("M-<Tab>"                , addName "Cycle all layouts"               $ sendMessage NextLayout)
    , ("M-S-<Tab>"              , addName "Reset layout"                    $ setLayout $ XMonad.layoutHook conf)

    , ("M-y"                    , addName "Float tiled w"                   $ withFocused toggleFloat)
    , ("M-S-y"                  , addName "Tile all floating w"             $ sinkAll)

    , ("M-,"                    , addName "Decrease master windows"         $ sendMessage (IncMasterN (-1)))
    , ("M-."                    , addName "Increase master windows"         $ sendMessage (IncMasterN 1))

    , ("M-t"                    , addName "Reflect/Rotate"              $ tryMsgR (Rotate) (XMonad.Layout.MultiToggle.Toggle REFLECTX))
    , ("M-S-r"                  , addName "Force Reflect (even on BSP)" $ sendMessage (XMonad.Layout.MultiToggle.Toggle REFLECTX))


    -- If following is run on a floating window, the sequence first tiles it.
    , ("M-f"                   , addName "Fullscreen"                      $ sequence_ [ (withFocused $ windows . W.sink)
                                                                        , (sendMessage $ XMonad.Layout.MultiToggle.Toggle FULL) ])

    -- Fake fullscreen fullscreens into the window rect. The expand/shrink
    -- is a hack to make the full screen paint into the rect properly.
    -- The tryMsgR handles the BSP vs standard resizing functions.
    , ("M-S-f"                  , addName "Fake fullscreen"             $ sequence_ [ (P.sendKey P.noModMask xK_F11)
                                                                                    , (tryMsgR (ExpandTowards L) (Shrink))
                                                                                    , (tryMsgR (ExpandTowards R) (Expand)) ])
    ]
        where
          toggleCopyToAll = wsContainingCopies >>= \ws -> case ws of
                           [] -> windows copyToAll
                           _ -> killAllOtherCopies

    -----------------------------------------------------------------------
    -- Screens
    -----------------------------------------------------------------------

-- Mouse bindings: default actions bound to mouse events
-- Includes window snapping on move/resize using X.A.FloatSnap
-- Includes window w/h ratio constraint (square) using X.H.ConstrainedResize
myMouseBindings (XConfig {XMonad.modMask = myModMask}) = M.fromList $

    [ ((myModMask,               button1) ,(\w -> focus w
      >> mouseMoveWindow w
      >> ifClick (snapMagicMove (Just 50) (Just 50) w)
      >> windows W.shiftMaster))

    , ((myModMask .|. shiftMask, button1), (\w -> focus w
      >> mouseMoveWindow w
      >> ifClick (snapMagicResize [L,R,U,D] (Just 50) (Just 50) w)
      >> windows W.shiftMaster))

    , ((myModMask,               button3), (\w -> focus w
      >> mouseResizeWindow w
      >> ifClick (snapMagicResize [R,D] (Just 50) (Just 50) w)
      >> windows W.shiftMaster))

    , ((myModMask .|. shiftMask, button3), (\w -> focus w
      >> Sqr.mouseResizeWindow w True
      >> ifClick (snapMagicResize [R,D] (Just 50) (Just 50) w)
      >> windows W.shiftMaster ))


    ]

---------------------------------------------------------------------
--MAIN
---------------------------------------------------------------------
main = do
   
  xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobarrc0"

  xmonad 
    $ addDescrKeys' ((myModMask, xK_F12), showKeybindings) myKeys
    $ ewmh 
    $ desktopConfig 
    {
      manageHook         = manageHook desktopConfig <+> manageDocks <+> namedScratchpadManageHook myScratchpads
    , workspaces         = myWorkspaces 
    , terminal           = myTerminal
    , modMask            = myModMask
    , mouseBindings      = myMouseBindings
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myBorderNormalColor
    , focusedBorderColor = myBorderFocusedColor
    , layoutHook         = myLayouts
    , startupHook        = myStartupHook
    , handleEventHook    = myHandleEventHook
    , logHook            = dynamicLogWithPP xmobarPP
                    {
			  ppOutput = \x -> hPutStrLn xmproc x  -- >> hPutStrLn xmproc1 x  >> hPutStrLn xmproc2 x
                        , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                        , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#F07178" ""        -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#d0d0d0" "" . shorten 80     -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> | </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                    }
    } 



