'perspective.bas
'17/07/06

'how it works:
'two vanishing points defined, two centre vertices defined..
'lines drawn from each VP to each vertex.
'angle from each VP to top 2 vertices are then found, and used in the aline sub 
'to go up the lines by a certain amount (magnitude), this time in white.
'two more lines drawn from each VP to this point on the line, these lines
'intersect to form the top of the cube.
'the 'dropline' function is then used to form the sides of the cube. two lines 
'are 'dropped' down from the cube corners until a grey construction line is
'found.

'return angle between two coordinates
declare function getangle(x0, y0, x1, y1) as single
'return (via currentx,y) coords a certain angle and magnitude away from x0,y0
declare sub aline(x0, y0, byval angle as single, magnitude as single)
'drop line down until a construction line (88888h) is found
declare function dropline (x, byval y)

dim shared currentx, currenty
const pi as double = 4 * atn(1)

'define window and video buffer size
screen 18, 32, 2
screenset 0, 1

'vanishing point coordinates
vp1x = -50: vp1y = -50

'vp2x = 550:vp2y = 50
vp2x = 640:vp2y = 0

'place cursor in middle of window
setmouse 320, 200

'main loop
do
     'clear screen
     cls
     
     print "2-point perspective demo - M0KSR      FreeBASIC 0.16w"
     print "right-click to exit - mod G7TKM"
     
     'get mouse coords and button status
     getmouse mx, my,, mb
     
     'place top vertex at mouse cursor...
     p1x = mx
     p1y = my
     '...and bottom vertex underneath it
     p2x = p1x
     p2y = p1y + 150

     'lines to top vertex
     line (vp1x, vp1y)-(p1x, p1y), &hff8888
     line (vp2x, vp2y)-(p1x, p1y), &h88ff88

     'lines to bottom vertex
     line (vp1x, vp1y)-(p2x, p2y), &h888888
     line (vp2x, vp2y)-(p2x, p2y), &h888888

     'connect vertices to form centre edge
     line (p1x, p1y)-(p2x, p2y)

     'form cube
     aline (p1x, p1y, getangle(p1x, p1y, vp1x, vp1y), 100)
     line (p1x, p1y)-(currentx, currenty)
     line (vp2x, vp2y)-(currentx, currenty), &hff8888
     line (currentx, currenty)-(currentx, dropline(currentx, currenty))		'dropline
     
     '...and from the other V.P.
     aline (p1x, p1y, getangle(p1x, p1y, vp2x, vp2y), 175)
     line (p1x, p1y)-(currentx, currenty)
     line (vp1x, vp1y)-(currentx, currenty), &h88ff88
     line (currentx, currenty)-(currentx, dropline(currentx, currenty))		'dropline
     
     'copy frame to video
     screencopy
     
     'allow other processes to continue (otherwise uses up 100% CPU)
     sleep 20

loop until mb = 2


function getangle(x0, y0, x1, y1) as single
   
     return 360 - atan2(x0 - x1, y0 - y1) * 57.29577951308232
     
end function

sub aline(x0, y0, byval angle as single, magnitude as single)
     
     angle -= 90
     dim as single adj, opp
     adj = (cos(angle * (pi / 180))) * magnitude
     opp = (tan(angle * (pi / 180))) * adj
     'line (x0, y0)-(x0 + adj, y0 + opp)
     currentx = x0 + adj
     currenty = y0 + opp
     
     
end sub

function dropline (x, byval y)
     
     oldy = y
     
     do
          y += 1
          if point(x, y) = &h888888 and y - oldy > 5 then return y
     loop until y - oldy > 1000
     
end function
