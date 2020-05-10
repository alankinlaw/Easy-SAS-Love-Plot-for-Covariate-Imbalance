/*************************************************************************************************************************

Title: Easy-SAS-Love-Plot-for-Covariate-Imbalance (%love macro)

The %love SAS macro allows the user to quickly and easily produce graphical displays of covariate imbalance 
before and after adjustment, based on plots developed by Thomas Love.

Author: Alan Kinlaw
Created: 09 May 2020
Updated: 10 May 2020

README

Goal: To create a figure that shows covariate imbalance across levels of a binary treatment/exposure 
before and after adjustment by weighting or matching.

Inputs:

	Standardized mean differences can either be generated in SAS or imported into SAS, and then fed 
	into to this macro.

	The INPUT DATASET must contain three columns:

	    1. COVARIATE: a list of the names of each covariate for which balance across exposure/treatment 
		groups is being assessed, written as you might want it to appear in a manuscript's typical Table 1;

	    2. CRUDE: standardized mean differences for each covariate in the crude (unadjusted) data; and

	    3. POST: standardized mean differences for each covariate after weighting, matching, or standardization

	The input dataset can contain more than these three variables, but only these three will be used by 
	the %love macro.

Outputs:

	A figure (.png file) that displays standardized mean differences for each covariate of interest in 
	crude and adjusted data.

Steps:

    1. Generate the input dataset described above.

    2. Identify filepath for the working directory that holds the input dataset and will be the target 
	location for the output figure.

    3. Specify the three required input parameters for the %love macro (i-iii):

	    i. The WORKING_DIRECTORY parameter: Specify the directory that contains the input dataset and 
		where the final plots will be stored.

	    ii. The SORTCHOICE parameter has two specification options, "sorted" or "original" (not case sensitive):

	        SORTED: The figure will display covariates in descending magnitude of crude 
			standardized mean difference.

	        ORIGINAL: The figure will display covariates in the order provided in the input dataset.

	    iii. The METHOD parameter has two specification options, "w" or "m" (not case sensitive):

	        W: The figure key will specify that weighting was used to balance covariates.

	        M: The figure key will specify that matching was used to balance covariates.

	4. If desired, two optional parameters may be modified in the macro call. These will receive default 
	values if not modified.

	    iv. The THRESHOLD parameter: Specify the absolute value of your threshold for identifying potentially 
		meaningful covariate imbalance. This will generate reference lines in the figure. If you do not want 
		threshold reference lines in the figure, then specify a value of threshold=0 in your call of the %love 
		macro. The default threshold is 0.1.

	    v. The HORIZONTAL parameter has two recommended specification options, "bands" or "lines" (case sensitive).

	        bands: This default setting will use light gray horizontal bands to guide the reader's eye 	
			horizontally across the figure from covariate names to their standardized mean differences.

	        lines: The figure will use light gray horizontal lines to guide the reader's eye from labels to values.

	        A third option is to use neither bands nor lines, which leaves no guide for the reader's eye. If this 
			is desired, then specify "HORIZONTAL = " in your call of the %love macro.

    5. Execute the macro.

        Example macro call for a magnitude-sorted, weight-based figure using defaults for parameters iv (0.1) and v (bands):

        %love(working_directory = insert-filepath-here, 
			  sortchoice = sorted, 
			  method = WEIGHT);

****************************************************************************************************************************/

options mprint mlogic;

%macro love(working_directory, sortchoice, method, threshold=.1, horizontal=bands);
	%let gpath="&working_directory"; %let path=&working_directory; %let dpi=300; 
	%if &method = w or &method = W %then %let method = Weighted; %else %if &method = m or &method = M %then %let method = Matched; 
	%if &horizontal = bands %then %let horizontal2 = colorbands=even colorbandsattrs=(color=black transparency=0.95);
	%else %if &horizontal = lines %then %let horizontal2 = grid;
	%else %if &horizontal =  %then %let horizontal2 = ;
	data _null_; call symputx('timestamp', put(datetime(), B8601DT.)); run;
	ods graphics / reset noborder imagename="love_&sortchoice._&method._&threshold._&horizontal._&timestamp"; ods html close; ods listing gpath=&gpath image_dpi=&dpi; 

	data table_original; set table; abscrude = abs(crude); abspost = abs(post); maxabs10 = max(abspost,abscrude)*10; ulimit = ceil(maxabs10)/10; llimit = ulimit*(-1); run;
	proc sql noprint; select min(llimit) into :lowerbound from table_original; select max(ulimit) into :upperbound from table_original;	quit;
	proc sort data=table_original out=table_sorted; by descending crude; run;
	
	%if &threshold ne 0 %then %do;
		proc sgplot data=table_&sortchoice noborder;
			refline -&threshold &threshold / name="reflines" legendlabel = "Thresholds" axis=x lineattrs=(pattern=dot color=black);
			refline 0 / axis=x lineattrs=(color=black);	
			scatter y=covariate x=crude / name="scatter1" legendlabel="Crude" markerattrs=(symbol=diamond color=black) markeroutlineattrs=(color=black thickness=2);
			scatter y=covariate x=post / name="scatter2" legendlabel="&method" markerattrs=(symbol=circlefilled color=black);
			yaxistable covariate / location=outside position=left valuejustify=left valueattrs=(size=7) nolabel labelattrs=(size=8);
			xaxis min=&lowerbound max=&upperbound values=(&lowerbound to &upperbound by .2) label='Standardized mean difference' ;	
			yaxis &horizontal2 fitpolicy=none valueattrs=(size=7) reverse display=none;
			keylegend "scatter1" "scatter2" "reflines" / location=inside position=bottomright outerpad=15 opaque down=3;
			run;	
		%end;
	%else %if &threshold = 0 %then %do;
		proc sgplot data=table_&sortchoice noborder;
			refline 0 / axis=x lineattrs=(color=black);	
			scatter y=covariate x=crude / name="scatter1" legendlabel="Crude" markerattrs=(symbol=diamond color=black) markeroutlineattrs=(color=black thickness=2);
			scatter y=covariate x=post / name="scatter2" legendlabel="&method" markerattrs=(symbol=circlefilled color=black);
			yaxistable covariate / location=outside position=left valuejustify=left valueattrs=(size=7) nolabel labelattrs=(size=8);
			xaxis min=&lowerbound max=&upperbound values=(&lowerbound to &upperbound by .2) label='Standardized mean difference' ;	
			yaxis &horizontal fitpolicy=none valueattrs=(size=7) reverse display=none;
			keylegend "scatter1" "scatter2" / location=inside position=bottomright outerpad=15 opaque down=3;
			run;
		%end;
	 
%mend;

* To uncomment an example call, highlight it and simultaneously type CTRL+SHIFT+/ --- to recomment it out, highlight it and simultaneously type CTRL+/ ;

* Example macro call for a magnitude-sorted, weighting-based figure that uses defaults for threshold and eye-guide parameters (D,E);
/*%love(working_directory = insert-filepath-here,*/
/*	  sortchoice = sorted,*/
/*	  method = w);*/

* Example macro call for an original-order, weighting-based figure that changes the balance threshold to 0.08 and uses eye-guide lines instead of bands;
/*%love(working_directory = insert-filepath-here,*/
/*	  sortchoice = original,*/
/*	  method = w,*/
/*	  threshold = 0.08,*/
/*	  horizontal = lines);*/

* Example macro call for a magnitude-sorted, matching-based figure that eliminates threshold lines and eye-guide lines or bands;
/*%love(working_directory = insert-filepath-here,*/
/*	  sortchoice = sorted,*/
/*	  method = m,*/
/*	  threshold = 0,*/
/*	  horizontal =);*/
