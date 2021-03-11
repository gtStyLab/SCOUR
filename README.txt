SCOUR: A stepwise machine learning framework for predicting metabolite-dependent regulatory interactions


Folder Descriptions
-------------------
BiggerModelData: contains files to generate ODE data for bigger synthetic model.

ChassData: contains files to generate ODE data for E. coli model.

createRegSchemes: contains files to create lists of regulatory interactions tested within SCOUR.

dataPreparationFiles: contains files to autogenerate training data and generate triplicate noisy ODE data. The noisy data is smoothed and the median is taken from the triplicates.

extraFiles: contains extra files necessary for some features and plots

featureGeneration: contains files to create feature matrices and calculate their features

HynneData: contains files to generate ODE data for yeast model.

plotFigures: contains files to plot figures found in the manuscript

results: contains compact results (large datasets (e.g. training datasets) removed) found in the manuscript and used for plotting

SmallerModelData: contains files to generate ODE data for smaller synthetic model.

Main File Descriptions
----------------------
SCOUR_Ecoli_noiseless.m: Predicts interactions in the E. coli model using SCOUR with noiseless datasets.
SCOUR_Ecoli_noisy.m: Predicts interactions in the E. coli model using SCOUR with noisy datasets.
SCOUR_Ecoli_random.m: Predicts interactions in the E. coli model using a random classifier with noisy datasets.
SCOUR_Synthetic_noiseless.m: Predicts interactions in the synthetic models using SCOUR with noiseless datasets.
SCOUR_Synthetic_noisy.m: Predicts interactions in the synthetic models using SCOUR with noisy datasets.
SCOUR_Synthetic_random.m: Predicts interactions in the synthetic models using a random classifier with noisy datasets.
SCOUR_Yeast_noiseless.m: Predicts interactions in the yeast model using SCOUR with noiseless datasets.
SCOUR_Yeast_noisy.m: Predicts interactions in the yeast model using SCOUR with noisy datasets.
SCOUR_Yeast_random.m: Predicts interactions in the yeast model using a random classifier with noisy datasets.
