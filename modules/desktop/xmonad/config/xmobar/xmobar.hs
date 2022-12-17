Config {
  font = "xft:FiraCode-10",
  additionalFonts = [ "xft:Hack Nerd Font Mono:size=15:bold"
                    ],

  bgColor = "#002b36",
  fgColor = "#268bd2",
  position = Top,

  sepChar = "%",
  alignSep = "}{",
  template = "<box type=Bottom width=2 color=#268bd2>%XMonadLog%</box> <box type=Bottom width=2 color=#268bd2>%memory% + %swap%</box> <box type=Bottom width=2 color=#268bd2>%dynnetwork%</box>}{<action=`refresh-background`>[~]</action> %uptime% %alsa:default:Master% %battery% %date% <box type=Bottom width=2 color=#268bd2>%uname%</box>",

  commands =
    [ Run DynNetwork
      [ "--template" , "<dev>: <rx>kB/s|<tx>kB/s"
      , "--Low"      , "10000"       -- units: B/s
      , "--High"     , "200000"       -- units: B/s
      , "--low"      , "darkgreen"
      , "--normal"   , "darkorange"
      , "--high"     , "darkred"
      ] 10
    ,  Run Battery
      [ "--template" , "<box type=Bottom width=2 color=#268bd2><acstatus></box>"
      , "--Low"      , "10"        -- units: %
      , "--High"     , "80"        -- units: %
      , "--low"      , "darkred"
      , "--normal"   , "darkorange"
      , "--high"     , "darkgreen"
      , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<left>%"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#dAA520>Charging (<left>%)</fc>"
                                       -- charged status
                                       , "-i"	, "<fc=#006000>Charged</fc>"
    ] 50
    , Run Uptime
      [ "-t", "<box type=Bottom width=2 color=#268bd2>Uptime: <days>d <hours>h <minutes>m</box>"
      ] 10
    , Run Alsa "default" "Master"
      [ "-t", "<box type=Bottom width=2 color=#268bd2>Vol <action=`amixer set Master 10%- > /dev/null`>-</action> <volumebar> <action=`amixer set Master 10%+ > /dev/null`>+</action> <action=`amixer set Master toggle`><status></action></box>"
      ]
    , Run Memory ["-t","Mem: <usedbar>"] 10
    , Run Swap ["-t", "<usedratio>%"] 10
    , Run Com "uname" ["-n", "-s","-r"] "" 36000
    , Run Date "<box type=Bottom width=2 color=#268bd2><fn=1></fn> %_b %_d %Y %H:%M:%S</box>" "date" 10
    , Run XMonadLog
    ]
}
