// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17275 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17275
//
// <-- Short Description -->
// legend: Scilab crashes when an empty value is used as first input argument and 5 as the second one

plot(1:10);
for i=[-6:-1 1:5]
    l = legend([], i);
    assert_checkequal(l, []);
end
