// BSD 2-Clause License
// 
// Copyright (c) 2025, Morgan Conner
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
// 
// * Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// 
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

///////////////////////////////////////////////////////////////////////////////
// Creality K2 Plus Extended Exhaust Cover
//
// This model provides a replacement exhaust cover for K2 Plus with room for a
// 10x11cm filter.
//
// Design Note:
// 
// BOSL2 does provide a honeycomb wall. Replacing the slats with the honeycomb
// offers little airflow improvement but drastically increases the supports and
// printing time required.
//
// Printing Notes:
// 
// 1. Select the appropriate material for this print. PETG will work if you do
//    not print with other high temperature materials. If you do, consider ABS,
//    or ASA for this model so it will not deform. Do not use PLA.
// 2. This print must be oriented on its left or right side when printing. This
//    is more awkward but is required for the U clip to function without
//    breaking.
// 3. The print will require supports. A alternate support interface material
//    is recommended so that support removal does not break or stress the clip
//    or the feet.
// 
///////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////
// Include The Belfry OpenScad Library, v2.0
// from https://github.com/BelfrySCAD/BOSL2
include <BOSL2/std.scad>
include <BOSL2/turtle3d.scad>

// Calcs
offset=.001;
offset2=.002;
$fa=0.024;
$fs=0.3;

// Define the path for the U clip
clip = turtle(["move", 8.5, "arcleft", 3, 175, "move", 1.5, "arcright",.5, 70, "move", .75, "arcleft",.5, 165, "move", 1.5, "arcright", .5, 90,"move",8]);

diff()
rect_tube(h=12, size=[106,114], isize=[100,110], chamfer=.5) {
    // The rect_tube provides the basic shape, but does not provide for chamfer around the openings
    
    // Chamfer outside bottom edges
    edge_mask(BOTTOM+LEFT) chamfer_edge_mask(l=114, chamfer=.5);
    edge_mask(BOTTOM+RIGHT) chamfer_edge_mask(l=114, chamfer=.5);
    edge_mask(BOTTOM+FRONT) chamfer_edge_mask(l=110, chamfer=.5);
    edge_mask(BOTTOM+BACK) chamfer_edge_mask(l=110, chamfer=.5);
    
    // Chamfer the outside bottom corners
    corner_mask(BOTTOM+LEFT+BACK) chamfer_corner_mask(chamfer=.5);
    corner_mask(BOTTOM+RIGHT+BACK) chamfer_corner_mask(chamfer=.5);
    corner_mask(BOTTOM+LEFT+FRONT) chamfer_corner_mask(chamfer=.5);
    corner_mask(BOTTOM+RIGHT+FRONT) chamfer_corner_mask(chamfer=.5);
    
    // Chamfer outside top edges
    edge_mask(TOP+LEFT) chamfer_edge_mask(l=114, chamfer=.5);
    edge_mask(TOP+RIGHT) chamfer_edge_mask(l=114, chamfer=.5);
    
    // Chamfer outside top back edge avoiding the clip
    translate([-29,0,0]) edge_mask(TOP+BACK) chamfer_edge_mask(l=46.7, chamfer=.5);
    translate([29,0,0]) edge_mask(TOP+BACK) chamfer_edge_mask(l=46.7, chamfer=.5);
    
    // Chamfer outside top front edge avoiding the feet
    edge_mask(TOP+FRONT) chamfer_edge_mask(l=57.1, chamfer=.5);
    translate([-46.5,0,0]) edge_mask(TOP+FRONT) chamfer_edge_mask(l=14.1, chamfer=.5);
    translate([46.5,0,0]) edge_mask(TOP+FRONT) chamfer_edge_mask(l=14.1, chamfer=.5);
    
    // Chamfer outside top corners
    corner_mask(TOP+LEFT+BACK) chamfer_corner_mask(chamfer=.5);
    corner_mask(TOP+RIGHT+BACK) chamfer_corner_mask(chamfer=.5);
    corner_mask(TOP+LEFT+FRONT) chamfer_corner_mask(chamfer=.5);
    corner_mask(TOP+RIGHT+FRONT) chamfer_corner_mask(chamfer=.5);
    
    // Chamfer inside top left and right edges
    translate([3,0,0]) edge_mask(TOP+LEFT) chamfer_edge_mask(l=106, chamfer=.5);
    translate([-3,0,0]) edge_mask(TOP+RIGHT) chamfer_edge_mask(l=106, chamfer=.5);

    //Add feet to the frame
    translate([-34,0,0]) attach(TOP, BOTTOM, align=FRONT, inset=offset)
        cuboid(size=[10,2,.5], chamfer=-.4, edges=[BOT+LEFT,BOT+RIGHT])
            attach(TOP, BOTTOM, align=BACK, inset=offset)
                cuboid(size=[10,5,2], rounding=.3, edges=[FRONT, TOP]);
    translate([34,0,0]) attach(TOP, BOTTOM, align=FRONT, inset=offset)
        cuboid(size=[10,2,.5], chamfer=-.4, edges=[BOT+LEFT,BOT+RIGHT])
            attach(TOP, BOTTOM, align=BACK, inset=offset)
                cuboid(size=[10,5,2], rounding=.3, edges=[FRONT, TOP]);

    // Translate the U clip path to an object and attach to back
    translate([0,-1.5-offset,1.25]) attach(BACK, FRONT) xrot(-45) zrot(-90) 
        path_sweep(rect([1.5,11]), clip);
        
    // Attach screen to bottom of frame
    attach(BOTTOM, BOTTOM, inside=true, align=CENTER, inset=offset)
        tag("keep") difference() {
            cuboid(size=[100+offset, 110+offset, 2]);
            // Create slats in the screen
            xcopies(spacing=33, n=3) ycopies(spacing=7.5, n=14)
                translate([0,0,-0.001])cuboid(size=[30, 5, 2+.002], chamfer=-.5);
        }
    // Attach a small lip to hold in a filter (also helps the frame during printing
    translate([0,-2,0]) attach(BACK, BACK, inside=true, align=TOP)
        tag("keep") cuboid(size=[101, 2, 0.75], rounding=.1, edges=[FRONT+TOP, FRONT+BOTTOM]);
    translate([0, 2,0]) attach(FRONT, FRONT, inside=true, align=TOP)
        tag("keep") cuboid(size=[101, 2, 0.75], rounding=.1, edges=[BACK+TOP, BACK+BOTTOM]);
}