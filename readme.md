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
1. COVARIATE -- a list of the names of each covariate for which balance across exposure/treatment groups is being assessed, written as you might want it to appear in a manuscript's typical Table 1;
2. CRUDE -- standardized mean differences for each covariate in the crude (unadjusted) data; and 
3. POST -- standardized mean differences for each covariate after weighting, matching, or standardization 

The input dataset can contain more than these three variables, but only these three will be used by the %love macro.

## Outputs

A figure (.png file) displaying crude and weighted or matched standardized differences for each covariate of interest

## Steps

1. Generate the input dataset described above.
2. Identify filepath for the working directory that holds the input dataset and will be the target location for the output figure.
3. Specify the three required input parameters for the %love macro (i-iii):
	
   i. <b>WORKING_DIRECTORY</b>: Specify the directory that contains the input dataset and where the final plots will be stored.
	
   ii. <b>SORTCHOICE</b> has two specification options, "sorted" or "original" (not case sensitive):

      - <b>SORTED</b>: The figure will display covariates in descending magnitude of crude standardized mean difference.
		
      - <b>ORIGINAL</b>: The figure will display covariates in the order provided in the input dataset.
			
   iii. <b>METHOD</b> has two specification options, "w" or "m" (not case sensitive):
   
      - <b>W</b>: The figure key will specify that weighting was used to balance covariates.
		
      - <b>M</b>: The figure key will specify that matching was used to balance covariates. 
		
		
4. If desired, two optional parameters may be modified in the macro call. These will receive default values if not modified.
		
    iv. <b>THRESHOLD</b>: Specify the absolute value of your threshold for identifying potentially meaningful covariate imbalance. This will generate reference lines in the figure. If you do not want threshold reference lines in the figure, then specify a value of <b>threshold=0</b> in your call of the %love macro. <i>The default threshold is 0.1.</i>
	
	v. <b>HORIZONTAL</b> has two recommended specification options, "bands" (the default) or "lines". Note that this parameter must be specified in <b>lowercase</b> only. <i>The default setting for this parameter is to use bands.</i>
		
	<b>bands</b>: This default setting will use light gray horizontal bands to guide the reader's eye horizontally across the figure from covariate names to their standardized mean differences. 
		
	  <b>lines</b>: The figure will use light gray horizontal lines to guide the reader's eye from labels to values. 
		
	  A third option is to use neither bands nor lines, leaving no guide for the reader's eye. If this is desired, then specify "HORIZONTAL = " in your call of the %love.
	

### Example
![](https://github.com/alankinlaw/Easy-Love-Plot/blob/master/example.png)
 
### License and warranty information

The published material is shared under a GNU General Public License v3.0.  It is being distributed without warranty of any kind, either expressed or implied. The responsibility for the interpretation and use of the material lies with the reader. In no event shall the Author be liable for damages arising from its use.
