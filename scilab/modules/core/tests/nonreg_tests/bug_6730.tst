// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2010 - INRIA - Serge.Steer@inria.fr
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug6730 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6730
//
// <-- Short Description -->
//problem with function calls when seen has member of an mlist

function [x,y,z]=myfun(varargin), x=varargin,y=2;z=3;,endfunction
function fun=%foo_e(name,M);  fun=myfun;endfunction
a=mlist('foo');
b=mlist(['foo','hello'],myfun);
c=mlist(['foo','hello'],list('xxxx','yyyyy','zzzzz'));

[x,y,z]=b.hello()
if x<>list()|y<>2|z<>3 then pause,end

[x,y,z]=a.hello()
if x<>list()|y<>2|z<>3 then pause,end

[x,y,z]=c.hello(1:3)
if x<>'xxxx'|y<>'yyyyy'|z<>'zzzzz' then pause,end

function [x,y,z]=myfun(varargin), x=varargin,y=2;z=3;,endfunction
function fun=%foo_e(name,M);  fun=myfun;endfunction

a=mlist('foo');
b=mlist(['foo','hello'],myfun);
c=mlist(['foo','hello'],list('xxxx','yyyyy','zzzzz'));

if b.hello()<>list()  then pause,end
if a.hello()<>list()  then pause,end
if or(c.hello()<>list('xxxx','yyyyy','zzzzz')) then pause,end

if or(b.hello(1:2)<>list(1:2))  then pause,end
if or(a.hello(1:2)<>list(1:2))  then pause,end
if c.hello(2)<>'yyyyy' then pause,end
