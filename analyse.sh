#! /usr/bin/env bash

python ./Pre_Analysis.py
R CMD BATCH Analyse_data.R
