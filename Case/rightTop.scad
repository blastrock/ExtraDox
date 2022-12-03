include <common.scad>

module part_rightTopCase() {
  //color("red", 0.5)
  difference() {
    translate([0, 0, layerIntersectBottom])
      polyRoundExtrude([ for (p = outerShell) [ p.x, p.y, caseRadius ] ], topLayerHeight+topLayerThickness-layerIntersectBottom, r1=0, r2=0);

    polyRoundExtrude([ for (p = boardPoints) [ p.x, p.y, caseRadius ] ], topLayerHeight, r1=0, r2=0);
    polyRoundExtrude([ for (p = midShellOut) [ p.x, p.y, caseRadius ] ], layerIntersectTop, r1=0, r2=0);

    forHoles(rightHolePositions) {
      screwHole();
      screwCountersink();
    }
    for ( s = rightSwitchPositions )
      translate ([s.x, s.y, -5])
        rotate (s.z)
          switchHole();

    for ( l = rightLedPositions )
      translate([l.x, l.y, 0])
        cube([2, 4, 20], center=true);

    translate ([rightJackPosition[0], rightJackPosition[1], boardHeight+boardThickness+2.5])
      rotate(-90, [0, 1, 0])
        jackHole();
    translate([rightUsbPosition[0], rightUsbPosition[1], boardHeight])
      rotate(-90, [1, 0, 0])
        usbcHole();
  }
}

part_rightTopCase();
