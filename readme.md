# Easy-SAS-Love-Plot-for-Covariate-Imbalance

The <b>%love</b> SAS macro allows the user to easily produce graphical displays of covariate imbalance before and after adjustment, based on plots developed by Thomas Love.

Author: Alan Kinlaw

Created: 09 May 2020

Updated: 10 May 2020


## Goal

To create a figure that shows covariate imbalance across levels of a binary treatment/exposure before and after adjustment by weighting or matching.


## Inputs

Standardized mean differences can either be generated in SAS or imported into SAS, and then fed into to this macro.

The INPUT DATASET must contain three columns:

1. <i>COVARIATE</i>: a list of the names of each covariate for which balance across exposure/treatment groups is being assessed, written as you might want it to appear in a manuscript's typical Table 1;

2. <i>CRUDE</i>: standardized mean differences for each covariate in the crude (unadjusted) data; and 

3. <i>POST</i>: standardized mean differences for each covariate after weighting, matching, or standardization 

The input dataset can contain more than these three variables, but only these three will be used by the %love macro.

## Outputs

A figure (.png file) displaying crude and weighted or matched standardized differences for each covariate of interest

## Steps

1. Generate the input dataset described above.
2. Identify filepath for the working directory that holds the input dataset and will be the target location for the output figure.
3. Specify the three required input parameters for the %love macro (i-iii):
	
   i. The <b>WORKING_DIRECTORY</b> parameter: Specify the directory that contains the input dataset and where the final plots will be stored.
	
   ii. The <b>SORTCHOICE</b> parameter has two specification options, "sorted" or "original" (not case sensitive):

      - <i>SORTED</i>: The figure will display covariates in descending magnitude of crude standardized mean difference.
		
      - <i>ORIGINAL</i>: The figure will display covariates in the order provided in the input dataset.
			
   iii. The <b>METHOD</b> parameter has two specification options, "w" or "m" (not case sensitive):
   
      - <i>W</i>: The figure key will specify that weighting was used to balance covariates.
		
      - <i>M</i>: The figure key will specify that matching was used to balance covariates. 
			
4. If desired, two optional parameters may be modified in the macro call. These will receive default values if not modified.
		
    iv. The <b>THRESHOLD</b> parameter: Specify the absolute value of your threshold for identifying potentially meaningful covariate imbalance. This will generate reference lines in the figure. If you do not want threshold reference lines in the figure, then specify a value of <b>threshold=0</b> in your call of the %love macro. <i>The default threshold is 0.1.</i>
    
    v. The <b>HORIZONTAL</b> parameter has two recommended specification options, "bands" or "lines" (<b>case sensitive</b>). 
    		
      - <i>bands</i>: This default setting will use light gray horizontal bands to guide the reader's eye horizontally across the figure from covariate names to their standardized mean differences. 
		
      - <i>lines</i>: The figure will use light gray horizontal lines to guide the reader's eye from labels to values. 
		
      - A third option is to use neither bands nor lines, which leaves no guide for the reader's eye. If this is desired, then specify "HORIZONTAL = " in your call of the %love macro.
	
5. Execute the macro. Example call:

		* Example macro call for a magnitude-sorted, weight-based figure using defaults for parameters iv and v ;
		%love(working_directory = C:\Users\akinlaw,
			  sortchoice = sorted,
			  method = WEIGHT);

### Example


![](C:\Users\akinlaw\OneDrive - University of North Carolina at Chapel Hill\Textandtools\Tools - SAS\easy-love-plot\love_sorted_Weighted__1_bands_20200510T174441.png)
 
### License and warranty information

The published material is shared under a GNU General Public License v3.0.  It is being distributed without warranty of any kind, either expressed or implied. The responsibility for the interpretation and use of the material lies with the reader. In no event shall the Author be liable for damages arising from its use.
