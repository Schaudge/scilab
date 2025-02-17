// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 8785 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8785
//
// <-- Short Description -->
//    Check inputs arguments in the modulo and pmodulo functions
// =============================================================================

assert_checkfalse(execstr("modulo", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "modulo", 2);
assert_checkerror("modulo", refMsg);

assert_checkfalse(execstr("pmodulo", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "pmodulo", 2);
assert_checkerror("pmodulo", refMsg);

assert_checkfalse(execstr("modulo(1)", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "modulo", 2);
assert_checkerror("modulo(1)", refMsg);

assert_checkfalse(execstr("pmodulo(1)", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "pmodulo", 2);
assert_checkerror("pmodulo(1)", refMsg);

assert_checkfalse(execstr("modulo(4*%i,1)", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "modulo", 1);
assert_checkerror("modulo(4*%i,1)", refMsg);

assert_checkfalse(execstr("modulo(10,%i)", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "modulo", 2);
assert_checkerror("modulo(10,%i)", refMsg);

assert_checkfalse(execstr("pmodulo(4*%i,1)", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "pmodulo", 1);
assert_checkerror("pmodulo(4*%i,1)", refMsg);

assert_checkfalse(execstr("pmodulo(10,%i)", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "pmodulo", 2);
assert_checkerror("pmodulo(10,%i)", refMsg);







