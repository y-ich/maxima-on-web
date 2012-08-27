#Maxima on Web
by ICHIKAWA, Yuji

Copyright (C) 2011-2012 ICHIKAWA, Yuji (New 3 Rs)

"Maxima on Web" is a server script by Sinatra(Ruby) with HTML client UI on MacOS.
It requires Maxima(http://maxima.sourceforge.net) and Gnuplot(included by Maxima distribution), and Sinatra(http://www.sinatrarb.com).


##How to set up for your environment

1. change a search path for Gnuplot in the file "maxima.rb"
    ENV['PATH'] = '/Applications/Gnuplot.app/Contents/Resources/bin:' + ENV['PATH'] # add search path for Gnuplot
    /Application/Gnuplot.app/Contents/Resources/bin is just for my environment. Change it for your environment.
2. change an absolute path for Maxima in the file "maxima.rb"
    MAXIMA_PATH = '/Applications/Maxima.app/Contents/Resources/maxima.sh' # set absolute path of Maxima
    /Applications/Maxima.app/Contents/Resources/maxima.sh is just for my environment. Change it for your environment.

## How to start web server

    ruby maxima_server.rb

Enjoy!
