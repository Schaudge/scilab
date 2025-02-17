// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2014 - Scilab Enterprises - Pierre-Aime Agnel
// Copyright (C) 2020 - Scilab Enterprises - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Unit test for function plotimplicit -->
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->

// Error checking
// --------------
fname = "plotimplicit";
// fun: string, macro, built-in, list expected
msg = msprintf("%s: Argument #%d: Real matrix or String or Scilab function or list expected.\n", fname, 1);
assert_checkerror("plotimplicit($)", msg);
msg = msprintf("%s: Argument #%d: Scalar (1 element) expected.\n", fname, 1);
assert_checkerror("plotimplicit([""x^2+y^2=1"",""x^2+y^2=1.2""])", msg);
msg = msprintf("%s: Argument #%d(#%d): Identifier of a Scilab or built-in function expected.\n", fname, 1, 1);
assert_checkerror("plotimplicit(list($))", msg);

// Function in input argument #1 must cross a zero
plotimplicit("10")  // Warning displayed

// x_grid:
msg = msprintf("%s: Argument #%d: Real vector or colon : expected.\n", fname, 2);
assert_checkerror("plotimplicit(""x^2+y^2=1"", ""not_a_real_vector"")", msg);
msg = msprintf("%s: Argument #%d: Real value expected.\n", fname, 2);
assert_checkerror("plotimplicit(""x^2+y^2=1"", [1 %i])", msg);
msg = msprintf("%s: Argument #%d: Vector expected.\n", fname, 2);
assert_checkerror("plotimplicit(""x^2+y^2=1"", rand(2,3))", msg);

// y_grid:
msg = msprintf("%s: Argument #%d: Real vector or colon : expected.\n", fname, 3);
assert_checkerror("plotimplicit(""x^2+y^2=1"", , ""not_a_real_vector"")", msg);
msg = msprintf("%s: Argument #%d: Real value expected.\n", fname, 3);
assert_checkerror("plotimplicit(""x^2+y^2=1"", , [1 %i])", msg);
msg = msprintf("%s: Argument #%d: Vector expected.\n", fname, 3);
assert_checkerror("plotimplicit(""x^2+y^2=1"", , rand(2,3))", msg);


// Nominal behaviour
// -----------------
function result = fun(x, y)
    result = 3 * x.^2 .* exp(x) - x .* y.^2 +  exp(y) ./ (y.^2 + 1) -1
endfunction

x_range = -1:0.01:1;
y_range = -10:0.01:10;

plotimplicit(fun, x_range, y_range, "r--");

a = gce();
// This plot is a compound of two polylines
data1 = a.children(1).data;
data2 = a.children(2).data;

for i = 1:size(data1, "r")
    // Check polyline is sufficiently close to 0
    assert_checktrue(abs(fun(data1(i, 1), data1(i, 2))) < 0.01);
end

for i = 1:size(data2, "r")
    // Check polyline is sufficiently close to 0
    assert_checktrue(abs(fun(data2(i, 1), data2(i, 2))) < 0.01);
end

// Possible inputs
// ---------------
// fun
clf
assert_checkequal(execstr("plotimplicit(""x^2+y^2=1"")", "errcatch"), 0);
ax = gca();
h = [ax.title ax.x_label ax.y_label];
assert_checkequal(h.text, ["$x^2+y^2=1$", "$x$", "$y$"]);
assert_checkequal(h.font_size, [4 4 4]);
xlabel("x");

assert_checkequal(execstr("plotimplicit(""x^2+y^2-2"")", "errcatch"), 0);
assert_checkequal(h.text, ["$x^2+y^2=1$", "x", "$y$"]);

clear fun
function result = fun(x, y, a, b, c)
    result = a * x.^2 .* exp(x) - x .* y.^2 +  exp(y) ./ (y.^2 + b) - c
endfunction
assert_checkequal(execstr("plotimplicit(list(fun,3,1,1))", "errcatch"), 0);

// x_grid
assert_checkequal(execstr("plotimplicit(""x^2+y^2=6"",[-2,3])", "errcatch"), 0);
assert_checkequal(execstr("plotimplicit(""x^2+y^2=6"",[3,-2])", "errcatch"), 0);
assert_checkequal(execstr("plotimplicit(""x^2+y^2=6"",-2:0.1:4)", "errcatch"), 0);
assert_checkequal(execstr("plotimplicit(""x^2+y^2=7"",:)", "errcatch"), 0);

// y_grid
assert_checkequal(execstr("plotimplicit(""x^2+y^2=6"",[-2,3],[-1 2])", "errcatch"), 0);
assert_checkequal(execstr("plotimplicit(""x^2+y^2=6"",      ,[-1 2])", "errcatch"), 0);
assert_checkequal(execstr("plotimplicit(""x^2+y^2=6"",[-2,3], :)", "errcatch"), 0);
assert_checkequal(execstr("plotimplicit(""x^2+y^2=6"",[-2,3],-1:0.1:2)", "errcatch"), 0);
assert_checkequal(execstr("plotimplicit(""x^2+y^2=0.5"",[-2,3],,""r"")", "errcatch"), 0);
