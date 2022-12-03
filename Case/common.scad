use <polyround.scad>
use <BOSL2/std.scad>
include <positions.scad>

boardThickness = 1.60;
caseRadius = 3;
bottomLayerThickness = 2;
boardHeight = bottomLayerThickness + 2;
topLayerThickness = 1.30;
topLayerOverBoard = boardThickness + 2.2-topLayerThickness;
topLayerHeight = topLayerOverBoard + boardHeight;
layerIntersectBottom = bottomLayerThickness + (topLayerHeight - bottomLayerThickness) / 2 - 0.5;
layerIntersectTop = bottomLayerThickness + (topLayerHeight - bottomLayerThickness) / 2 + 0.5;
screwHoleRadius = 3.2/2;
screwGuideBaseLargeRadius = 8/2;
screwGuideBaseRadius = 7/2;
screwGuideTopRadius = 5/2;
nutShortDiag = 5.4;
nutLongDiag = 2/sqrt(3) * nutShortDiag;

$fs = 0.5;

boardPoints = [
    [58, 64.5],
    [58, -62],
    [-11, -62],
    [-93, -100],
    [-118, -46],
    [-77, -27],
    [-77, 64.5],
];
outerShell = offset(boardPoints, delta=2, closed=true);
midShellIn = offset(boardPoints, delta=0.90, closed=true);
midShellOut = offset(boardPoints, delta=1.10, closed=true);

module base() {
  difference() {
    polyRoundExtrude([ for (p = outerShell) [ p.x, p.y, caseRadius ] ], layerIntersectTop, r1=0, r2=caseRadius);

    translate([0, 0, bottomLayerThickness])
      polyRoundExtrude([ for (p = boardPoints) [ p.x, p.y, caseRadius ] ], 10);
    translate([0, 0, layerIntersectBottom])
      difference() {
        translate([-150, -150, 0]) cube([300, 300, 10]);
        translate([0, 0, -5])
          polyRoundExtrude([ for (p = midShellOut) [ p.x, p.y, caseRadius ] ], 10, r1=0, r2=0);
      }
  }
}

module screwGuide() {
  color("green") cylinder(boardHeight, r1=screwGuideBaseLargeRadius, r2=screwGuideBaseRadius);
  //cylinder(topLayerHeight, r=screwGuideTopRadius);
}

module screwTopGuide() {
  cylinder(topLayerOverBoard-boardThickness+0.1, r=screwGuideTopRadius);
}

module screwCountersink() {
  h = 5;
  translate([0, 0, topLayerHeight-1])
    cylinder(h, r1=0, r2=h);
}

module screwHole() {
  translate([0, 0, -10])
    cylinder(r=screwHoleRadius, h=20);
}

module nutHole() {
  translate([0, 0, -1])
    cylinder(1+3, r=nutLongDiag/2, $fn=6);
}

module switchHole() {
  linear_extrude(100)
    square([14.3, 14], center=true);
}

module forHoles(holePositions) {
  for ( h = holePositions )
    translate([h.x, h.y])
      children();
}

module longHole(radius, width) {
  union() {
    translate([-width/2, 0])
    circle(radius);
    translate([+width/2, 0])
    circle(radius);
    square([width, radius*2], center=true);
  }
}

module usbcHole() {
  union() {
    linear_extrude(100)
      longHole(2, 6);
    translate([0, 0, 6])
      linear_extrude(100)
        longHole(3, 10);
  }
}

module jackHole() {
  union() {
    // linear_extrude(100)
    //   circle(d=6);
    translate([0, 0, -3])
      //cube([6, 6.5, 13], center=true);
      cube([10, 6.5, 20], center=true);
  }
}
