Config {
	font = "xft:Fira Code:size=10:bold:antialias=true",
        
	bgColor = "#002b36",
  fgColor = "#268bd2",
  position = TopW L 100,
 
	commands = [
	  Run Weather "EDDC" ["--template", "<fc=#4682B4><tempC></fc>°C | <fc=#4682B4><pressure></fc>hPa"] 36000,
          Run DynNetwork [
	  	"--template" , "<dev>: <rx>kB/s|<tx>kB/s"
                , "--Low"      , "10000"       -- units: B/s
                , "--High"     , "200000"       -- units: B/s
                , "--low"      , "darkgreen"
                , "--normal"   , "darkorange"
                , "--high"     , "darkred"
          ] 10, 
	  Run CoreTemp [
	  	"--template" , "Temp: (<core0>|<core1>|<core2>|<core3>)°C"
                , "--Low"      , "70"        -- units: °C
                , "--High"     , "80"        -- units: °C
                , "--low"      , "darkgreen"
                , "--normal"   , "darkorange"
                , "--high"     , "darkred"] 50,
          Run MultiCpu [
	  	"--template" , "Cpu: (<total0>|<total1>|<total2>|<total3>)%"
                , "--Low"      , "50"         -- units: %
                , "--High"     , "85"         -- units: %
                , "--low"      , "darkgreen"
                , "--normal"   , "darkorange"
                , "--high"     , "darkred"] 10, 
          Run Memory ["-t","Mem: <usedratio>%"] 10,
          Run Swap [] 10,
          Run Com "uname" ["-n", "-s","-r"] "" 36000,
          Run Date "%a %b %_d %Y %H:%M:%S" "date" 10,
          Run StdinReader
        ],

	-- layout
        sepChar = "%",
        alignSep = "}{",
        template = "%StdinReader% | %multicpu% %coretemp% | %memory% * %swap% | %dynnetwork% }{<fc=#ee9a00>%date%</fc> | %uname% | %EDDC% " 
}