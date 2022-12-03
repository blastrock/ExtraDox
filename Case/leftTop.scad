include <common.scad>

module part_leftTopCase() {
  //color("red", 0.5)
  difference() {
    union() {
      mirror([1,0,0])
        difference() {
          translate([0, 0, layerIntersectBottom])
            polyRoundExtrude([ for (p = outerShell) [ p.x, p.y, caseRadius ] ], topLayerHeight+topLayerThickness-layerIntersectBottom, r1=0, r2=0);
          polyRoundExtrude([ for (p = boardPoints) [ p.x, p.y, caseRadius ] ], topLayerHeight, r1=0, r2=0);
          polyRoundExtrude([ for (p = midShellOut) [ p.x, p.y, caseRadius ] ], layerIntersectTop, r1=0, r2=0);
        }

      translate([0, 0, boardHeight+boardThickness])
        forHoles(leftHolePositions) {
          screwTopGuide();
        }
    }

    forHoles(leftHolePositions) {
      screwHole();
      screwCountersink();
    }

    for ( s = leftSwitchPositions )
      translate ([s.x, s.y, -5])
        rotate (s.z)
          switchHole();
    translate ([leftJackPosition[0], leftJackPosition[1], boardHeight+boardThickness+2.5])
      rotate(90, [0, 1, 0])
        jackHole();
  }
}

part_leftTopCase();
