Config {
  font = "xft:Fira Code:size=10:bold",

  bgColor = "#002b36",
  fgColor = "#268bd2",
  position = TopW L 100,

  sepChar = "%",
  alignSep = "}{",
  template = "<box type=Bottom width=2 mb=2 color=#268bd2>%XMonadLog%</box> | %multicpu% %coretemp% | <box type=Bottom width=2 mb=2 color=#268bd2>%memory% + %swap%</box> | %dynnetwork% }{<action=`sh .config/xmonad/xmobar/refreshBackground.sh`>[~]</action> %uptime% %alsa:default:Master% <box type=Bottom width=2 mb=2 color=#ee9a00><fc=#ee9a00>%date%</fc></box> <box type=Bottom width=2 mb=2 color=#268bd2>%uname%</box> ",

  commands =
    [ Run DynNetwork
      [ "--template" , "<dev>: <rx>kB/s|<tx>kB/s"
      , "--Low"      , "10000"       -- units: B/s
      , "--High"     , "200000"       -- units: B/s
      , "--low"      , "darkgreen"
      , "--normal"   , "darkorange"
      , "--high"     , "darkred"
      ] 10
    , Run CoreTemp
      [ "--template" , "Temp: (<core0>|<core1>|<core2>|<core3>)°C"
      , "--Low"      , "70"        -- units: °C
      , "--High"     , "80"        -- units: °C
      , "--low"      , "darkgreen"
      , "--normal"   , "darkorange"
      , "--high"     , "darkred"
      ] 50
    , Run MultiCpu
      [ "--template" , "<box type=Bottom width=2 mb=2 color=#268bd2>Cpu: <autovbar></box>"
      , "--Low"      , "50"         -- units: %
      , "--High"     , "75"         -- units: %
      , "--low"      , "darkgreen"
      , "--normal"   , "darkorange"
      , "--high"     , "darkred"
      ] 10
    , Run Uptime
      [ "-t", "<box type=Bottom width=2 mb=2 color=#268bd2>Uptime: <days>d <hours>h <minutes>m</box>"
      ] 10
    --! crashing xmobar on startup
    , Run Alsa "default" "Master"
      [ "-t", "<box type=Bottom width=2 mb=2 color=#268bd2>Vol <action=`amixer set Master 10%-`>-</action> <volumebar> <action=`amixer set Master 10%+`>+</action> <action=`amixer set Master toggle`><status></action></box>"
      ]
    -- , Run Com ".config/xmonad/xmobar/soundmixer.sh" [] "audio" 10
    , Run Memory ["-t","Mem: <usedbar>"] 10
    , Run Swap ["-t", "<usedratio>%"] 10
    , Run Com "uname" ["-n", "-s","-r"] "" 36000
    , Run Date "%a %b %_d %Y %H:%M:%S" "date" 10
    , Run XMonadLog
    ]
}
