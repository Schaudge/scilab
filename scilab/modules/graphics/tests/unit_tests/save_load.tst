// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Jean-Baptiste SILVY <jean-baptiste.silvy@inria.fr>
// Copyright (C) 2012 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// test to check that save and load are working properly
plotExportFile = pathconvert(TMPDIR) + "savePlot.hdf5";

// check clip properties
clf();
x = 0:10;
z = sin(x)'*cos(x);
plot3d(x, x, z);
e = gce();
e.clip_state = "clipgrf";
plot3d(x ,x ,z + 1);
e = gce();
e.clip_box = [1, 2, 3, 4];
e.clip_state = "on";

// save the two curves
f = gcf();
save(plotExportFile, "f");

// close window
delete(f);

// reload data
load(plotExportFile);
axes = gca();

// check axes properties
surf1 = axes.children(1);
if (surf1.clip_box <> [1, 2, 3, 4]) then pause; end
if (surf1.clip_state <> "on") then pause; end
surf2 = axes.children(2);
if (surf2.clip_box <> []) then pause; end
if (surf2.clip_state <> "clipgrf") then pause; end

// same for fac3d (surf())
clf();
nc = 128;
gcf().color_map = [coolwarm(nc); spectral(nc)];
[X,Y]=meshgrid(-1:0.1:1,-1:0.1:1);
surf(X, Y, X.^2-Y.^2, "facecolor", "interp");
gce().color_range = [nc+1 2*nc];
gce().cdata_bounds = [0 1];

// save the figure
f = gcf();
save(plotExportFile, "f");

// close window
delete(f);

// reload data
load(plotExportFile);
axes = gca();

// check properties
surf1 = axes.children(1);
if (surf1.color_range <> [nc+1 2*nc]) then pause; end
if (surf1.cdata_bounds <> [0 1]) then pause; end

// same for grayplot
clf();
x = 0:10;
z = sin(x)'*cos(x);
grayplot(x, x, z)
e = gce();
e.clip_state = "clipgrf";
grayplot(x, x, z + 1);
e = gce();
e.clip_box = [1, 2, 3, 4];
e.clip_state = "on";

// save the two curves
f = gcf();
save(plotExportFile, "f");

// close window
delete(f);

// reload data
load(plotExportFile);
axes = gca();

// check axes properties
surf1 = axes.children(1);
if (surf1.clip_box <> [1, 2, 3, 4]) then pause; end
if (surf1.clip_state <> "on") then pause; end
surf2 = axes.children(2);
if (surf2.clip_box <> []) then pause; end
if (surf2.clip_state <> "clipgrf") then pause; end

// same for Matplot
clf();
x = 0:10;
z = sin(x)'*cos(x);
Matplot(z)
e = gce();
e.clip_state = "clipgrf";
Matplot(z + 1);
e = gce();
e.clip_box = [1, 2, 3, 4];
e.clip_state = "on";

// save the two curves
f = gcf();
save(plotExportFile, "f");

// close window
delete(f);

// reload data
load(plotExportFile);
axes = gca();

// check axes properties
surf1 = axes.children(1);
if (surf1.clip_box <> [1, 2, 3, 4]) then pause; end
if (surf1.clip_state <> "on") then pause; end
surf2 = axes.children(2);
if (surf2.clip_box <> []) then pause; end
if (surf2.clip_state <> "clipgrf") then pause; end


// same for fec
clf();
x = 0:10;
z = sin(x)'*cos(x);
Sgrayplot(x, x, z)
e = gce();
e = e.children(1);
e.clip_state = "clipgrf";
Sgrayplot(x, x, z + 1)
e = gce();
e = e.children(1);
e.clip_box = [1, 2, 3, 4];
e.clip_state = "on";

// save the two curves
f = gcf();
save(plotExportFile, "f");

// close window
delete(f);

// reload data
load(plotExportFile);
axes = gca();

// check axes properties
surf1 = axes.children(1).children(1);
if (surf1.clip_box <> [1, 2, 3, 4]) then pause; end
if (surf1.clip_state <> "on") then pause; end
surf2 = axes.children(2).children(1);
if (surf2.clip_box <> []) then pause; end
if (surf2.clip_state <> "clipgrf") then pause; end

// axis
clf();
a = gca();//get the handle of the newly created axes
a.data_bounds=[-1,-1;10,10];

drawaxis(x=2:7,y=4,dir='u');
a1=a.children(1);
a1.xtics_coord=[1 4 5  8 10];
a1.tics_color=2;
a1.labels_font_size=3;
a1.tics_direction="bottom";
a1.tics_labels= [" February" "May"  "june" "August"  "October"];
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// legend
clf();
t=linspace(0,%pi,20);
a=gca();a.data_bounds=[t(1) -1.8;t($) 1.8];

plot2d(t,[cos(t'),cos(2*t'),cos(3*t')],[-5,2 3]);
e=gce();
e1=e.children(1);e1.thickness=2;e1.polyline_style=4;e1.arrow_size_factor = 1/2;
e.children(2).line_style=4;
e3=e.children(3);e3.line_mode='on';e3.mark_background=5;

hl=legend(['cos(t)';'cos(2*t)';'cos(3*t)']);
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// arc
clf();
plot2d(0,0,-1,"031"," ",[-1,-1,1,1])
arcs=[-1.0 0.0 0.5;
       1.0 0.0 0.5;
       0.5 1.0 0.5;
       0.5 0.5 1.0;
       0.0 0.0 0.0;
       180*64 360*64 90*64];
xarcs(arcs,[1,2,3])
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// rectangle
clf();
plot2d([-100,500],[-50,50],[-1,-1],"022")
cols=[-34,-33,-32,-20:5:20,32,33,34];
x=400*(0:14)/14; step=20;
rects=[x;10*ones(x);step*ones(x);30*ones(x)];
xrects(rects,cols)
xnumb(x,15*ones(x),cols)
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// xsegs
clf();
x=2*%pi*(0:9)/10;
xv=[sin(x);9*sin(x)];
yv=[cos(x);9*cos(x)];
plot2d([-10,10],[-10,10],[-1,-1],"022")
xsegs(xv,yv,1:10)
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// champ demo
clf();
champ();
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// plot demo
clf();
plot();
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// plot2d demo
clf();
plot2d();
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// plot3d demo
clf();
plot3d();
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// uicontrols demo
clf();
exec(SCI + filesep() + "modules/gui/demos/uicontrol_plot3d.dem.sce");
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

// uicontrols demo
clf();
exec(SCI + filesep() + "modules/gui/demos/uicontrol.dem.sce");
// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);


// datatip test
x=linspace(0,1,9)';
y=x.^3;
clf();
plot(x,y);
e=gce();p=e.children(1);//get the handle on the polyline
p.mark_mode="on";p.mark_style=2;p.mark_size=12;
t=datatipCreate(p,5);

// save the curves
f = gcf();
save(plotExportFile, "f");
// close window
delete(f);
// reload data
load(plotExportFile);

a = gca();
e = a.children.children;
assert_checkequal(e.datatips.data, [0.5, 0.125, 0]);
delete(f);
