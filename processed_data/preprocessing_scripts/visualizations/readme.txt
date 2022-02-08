This folder contains visualizations of the raw data of every participant on every trial


Gaze data is difficult to visualize because it consist of 3 dimensions (2 spatial,
x and y coordinates, and time). Since the most important dimensions in this experiment
are time (when do gaze shifts take place?) and the x-axis (do shifts go to the left or
right?) these two dimensions are taken as the main dimensions of the plot. On the y-axis 
the time (10 seconds) run from top to bottom and the AOIs are plotted with regard to 
the x-axis. These AOIs actually run over the full range of the y-axis (since they are
not constraint by time), but are broken at 4 seconds, as this is the crucial moment in
the experiment where gaze following can start to occur.

The middle (purple) AOI is the face AOI, the left and right AOI are either (green,
congruent) or (red, incongruent). The small boxes are the fixations that are identified
by the gazepath algorithm. These boxes are plotted at the position of their mean x-
coordinate and are used for the analyses. Boxes that fall in an AOI are every likely to
be fixations inside that AOI, however this is not necessarily the case. For instance,
fixations that fall in the purple face AOI can also fall below the face in between the 
two toys. On the other hand are fixations above the left and right AOIs and below the 
face AOI likely to fall into these AOIs. 

In blue the raw data signal of the x-coordinates for both eyes (or only one eye if only
one eye is tracked) is plotted, the red line(s) show the raw gaze coordinates with regard
to the y-axis. Lower (more towards the left) y-axis values correspond to locations towards
the top of the screen (face area) and higher (more rightwards values) correspond to 
locations towards the bottom of screen (toys)