// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel GOUGEON
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function t = %l_string_inc(s, parentType)
    // Internal function called by %st_p, %l_p, and %l_string_inc itself
    // Can be called with s = struct | Tlist | list

    ll    = lines()
    t     = []
    indentFields = "    "
    if parentType=="list" then
        eq = "= "
    else
        eq = " = "
    end

    if  typeof(s)=="st"
        multi = size(s,"*")

        // axb struct where a<>0 & b<>0
        if multi > 1 | recursive > maxDisplayDepth then
            t = [t ; fieldnames(s)]
            return
        end
    end

    recursive0 = recursive
    if type(s)==15 then
        Fields = 1:length(s)
    else
        Fields = fieldnames(s)'
    end

    // MAIN LOOP
    // ---------
    for field = Fields
        sep = ": "      //   field_name<sep> ...
        if type(s)==15 then
            fieldn = msprintf("(%d) ", field)
        else
            fieldn = field
        end
        clear value
        value = s(field)
        if isdef("value","l") then
            tp = typeof(value)
        else
            tp = "void"
        end

        if tp=="void" then
            str = _("(void)")
            sep = eq

        elseif tp == "st" then
            recursive = recursive + 1
            str = %l_string_inc(value, "st")

        elseif tp == "implicitlist"
            str = sci2exp(value)
            sep = eq

        elseif tp == "function"
            [out,inp,?] = string(value)
            if inp==[], inp = "", end
            if out==[], out = "", end
            p = macr2tree(value)
            str = p.name+"("+strcat(inp,",")+") => ["+strcat(out,",")+"] ";
            str = str + msprintf(_("(%d lines)"),p.nblines)
            txt = fieldn + ": " + str

        elseif tp == "rational"
            str = %r_outline(value); 

        elseif tp == "ce"
            if length(value)==0 then
                str = "{}"
                txt = fieldn + eq + str
            else
                str = %ce_outline(value);
                txt = fieldn + ": " + str
            end

        elseif type(value)==15
            if recursive < maxDisplayDepth
                recursive = recursive + 1
                tmp = %l_string_inc(value, "list")
                str = [%l_outline(value) ; tmp]
            else
                str = %l_outline(value);
            end
        elseif or(type(value)==[16 17])
            // Tlists or Mlists
            Tfields = fieldnames(value);
            err = 0;
            [str,err] = evstr("%"+tp+"_outline(value,1)");
            if err <> 0
                listType = "tlist"
                if type(value)==17
                    listType = "mlist"
                end
                if Tfields==[]
                    str = msprintf(_("[%s] %s without field"), tp, listType);
                else
                    str = msprintf(_("[%s] %s with fields:"), tp, listType);
                    if recursive < maxDisplayDepth
                        recursive = recursive + 1
                        tmp = %l_string_inc(value, "mtlist")
                        str = [str ; tmp]
                    else
                        tmp = sci2exp(Tfields', consoleWidth-10)
                        tmp = strsubst(strsubst(tmp, """", ""), ",", ", ")
                        str = [str ; tmp]
                    end
                end
            end
        elseif type(value)==14  // Library
            tmp = string(value)
            p = tmp(1)
            libname = xmlGetValues("/scilablib","name",p + "lib")
            str = msprintf("%s library with %d functions @ %s", ..
                           libname, size(tmp,1)-1, p)

        elseif type(value)> 10 then
            str = tp
        else
            sz = size(value)
            // If number of elements in value is greater than ll(1) (current
            // page width) then we do not call sci2exp because the returned
            // value will be ignored at line 68: size(str,"*")==1
            // Note that ll(1)/2 elements could be the max because of colon,
            //  semi-colon and brackets added between elements by sci2exp
            if sz(1) <= 1 & type(value) <> 9 & prod(sz) < ll(1) then
                // This line can avoid some memory issues when
                //  field contains a big matrix
                str = sci2exp(value, ll(1))
                sep = eq
            else
                [otype, oname] = typename();
                str = evstr("%"+oname(otype==type(value))+"_outline(value,0)")
            end
        end
        // ---------------------------
        if size(str,"*") == 1 & ..
               and(tp <> ["st" "function" "rational" "ce"])
            txt = fieldn + sep + str

        elseif and(tp <> ["function" "ce"])
            if recursive
                txt0 = indentFields    // indentation for fields list
                //txt0 = field + "."  // to display the chain of parent fields
            else
                txt0 = fieldn
            end
            if tp == "st"
                txt = fieldn + ": "
                txt = txt + %st_outline(value, 1);
                txt = [txt ; txt0 + str]
                if stripblanks(t($)) <> ""
                        txt = [l_p_compacity ; txt]
                end
            elseif or(type(value)==[15 16 17])
                txt = fieldn + ": " + str(1)
                if size(str,1)>1
                    txt = [txt ; indentFields + str(2:$)]
                end
                if stripblanks(t($)) <> ""
                    txt = [l_p_compacity ; txt]
                end
            else
                [otype, onames] = typename();
                txt = txt0 + ": " + evstr("%"+onames(otype==type(value))+"_outline(value,0)");
            end
        end
        t = [t ; txt]
        recursive = recursive0
    end
    // Display a blank line after each field that is a non-empty
    // struct or tlist:
    if recursive & stripblanks(t($)) <> ""
        t = [t ; l_p_compacity]
    end
endfunction
