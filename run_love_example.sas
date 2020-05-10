********************************************************************************

This example uses published standardized mean difference data from Table 1 of:

Mitchell AP, Kinlaw AC, Peacock-Hinton S, Dusetzina SB, Sanoff HK, Lund JL. 
Use of High-Cost Cancer Treatments in Academic and Nonacademic Practice. 
Oncologist. 2019:theoncologist.2019-0338. doi:10.1634/theoncologist.2019-0338

*********************************************************************************;

* Store the love.sas macro in a known location and paste that location in place of
"insert file-path-here" below. Then execute the %include statement, dataset 
creation, and whichever call(s) of the macro you wish to see. ;

%include "insert-filepath-here\love.sas";

data table;
input covariate $ 1-25 crude 27-32 post 34-39;
cards;
Female gender             0.007  0.065
Age                       0.112  -0.03
Nonwhite race             0.197  -0.088
Poverty prevalence        0.289  -0.015
Year of diagnosis         -0.394 -0.011
Type of insurance         -0.286 -0.055
Cancer type               0.199  0.067
Outpatient treatment      0.744  0.07
No. of contraindications  0.066  0.023
Recent surgery            0.092  -0.002
Gastrointestinal bleed    -0.066 -0.062
Brain metastasis          -0.056 -0.078
No. of frailty indicators 0.179  0.112
;run;

* Example macro call for a magnitude-sorted, weighting-based figure that uses defaults for threshold and eye-guide parameters (D,E);
%love(working_directory = C:\Users\akinlaw,
	  sortchoice = sorted,		
	  method = w);

* Example macro call for an original-order, weighting-based figure that changes the balance threshold to 0.08 and uses eye-guide lines instead of bands;
%love(working_directory = C:\Users\akinlaw,
	  sortchoice = original,
	  method = w,
	  threshold = 0.08,
	  horizontal = lines);

* Example macro call for a magnitude-sorted, matching-based figure that eliminates threshold lines and eye-guide lines or bands;
%love(working_directory = C:\Users\akinlaw,
	  sortchoice = sorted,		
	  method = m,
	  threshold = 0,
	  horizontal =);
