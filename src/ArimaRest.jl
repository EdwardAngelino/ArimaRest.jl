module ArimaRest

# Write your package code here.
 using SymPy, DelimitedFiles
 using LinearAlgebra
 using CSV, DataFrames, Plots
 #import Base.Meta

 export  restringido, grafica, df
 export  leedatostxt
 #export  coef, Ψ, k_calc
 include("arimarestringido.jl")
 include("grafico.jl")
 include("leearchivotxt.jl")
end
