


for f = (2:1:3)
    prmtrList = {'N','Uinf','TIinf','X'};
    names = {'U_{\infty}','TI_{\infty}'}
    load(['opt_sstvt' prmtrList{f} '_2.mat']);
    

    struct_sstvt.parameter = names{f-1};
end