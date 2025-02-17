// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018, 2019 - Lucien POVY
// Copyright (C) 2018, 2019 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15368 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15368
//
// <-- Short Description -->
// For some continuous time systems, freson() wrongly returned []

s = %s;
rtol = 1e-14;
sl1 = syslin("c",1,s*(s+1)*(1+s/3));
[K,P] = kpure(sl1);
sl = K*sl1;
taud = 1/imag(P);
sltaud = sl*(1+taud*s);         //first open loop
sltaud2 = sl*(1+2*taud*s);      //second open loop
ff = freson(sltaud/(1+sltaud)); //freson of first close loop
assert_checkalmostequal(ff, 0.32447218051387, rtol);

SLBF = sltaud2/(1+sltaud2); //THE CLOSE LOOP OF sltau2
fr6 = freson(SLBF);
assert_checkalmostequal(fr6, 0.48257117694410, rtol);

// ----------------------

num = s + 1.4*s^2 + 1.4*s^3 + 0.4*s^4 ;
den = 0.5 + 0.8*s + 1.4*s^2 + 1.4*s^3 + 0.4*s^4 ;
h = syslin("c", num, den);
assert_checkalmostequal(freson(h), 0.1111642261457733, rtol);

// ----------------------

h = syslin('c',-1+%s,(3+2*%s+%s^2)*(50+0.1*%s+%s^2));

hd = dscr(h, 0.05);
assert_checktrue(freson(hd) <> []);

hd = dscr(h, 0.02);
assert_checktrue(freson(hd) <> []);

hd = dscr(h, 0.01);
assert_checktrue(freson(hd) <> []);

hd = dscr(h, 0.005);
assert_checktrue(freson(hd) == []);
