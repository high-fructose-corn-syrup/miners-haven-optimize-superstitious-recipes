# miners-haven-optimize-superstitious-recipes
Constructs a linear system of constrained variables to minimize the crafting recipe cost for superstitious items in Miner's Haven

You can check [RECIPE.txt](src/RECIPE.txt) for a precomputed list of recipe's that use the code. 

## Use 

If you wish to run the program yourself for reasons of tweaking it to better fit your inventory then here are the steps.
#### Install required [Julia](https://julialang.org/) packages by opening a Julia REPL in your terminal. 
```julia
using Pkg
Pkg.add("JuMP")
Pkg.add("GLPK")
```
#### Run the script in your terminal by providing the path to `superstitious.jl` relative to the terminal's current working directory. 
```console
julia ./superstitious.jl
```
