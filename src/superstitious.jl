using JuMP
using GLPK
using DataFrames
using CSV

crafting_items = CSV.read("./resource/crafting.csv", DataFrames.DataFrame)
superstitious_items = CSV.read("./resource/superstitious.csv", DataFrames.DataFrame)

CRAFTING_ELEMENTS = ["aether", "earth", "water", "order", "fire", "entropy"]
MAX_CRAFTING_AMOUNT = 50
OPTIMIZER_TIME_LIMIT_MS = 4 * 60 * 1_000

function solve_coeff(item::DataFrames.DataFrameRow)
    model = Model(GLPK.Optimizer)

    set_optimizer_attribute(model, "tm_lim", OPTIMIZER_TIME_LIMIT_MS)

    @variable(model, 0 ≤ x[crafting_items.name] ≤ MAX_CRAFTING_AMOUNT, integer = true)

    for element ∈ CRAFTING_ELEMENTS 
        expression = @expression(
            model,
            sum(x[material["name"]] * material[element] for material ∈ eachrow(crafting_items))
        )

        @constraint(model, expression ≥ item[element])
    end

    @objective(
        model,
        Min,
        sum(x[material["name"]] / material["rarity"] for material ∈ eachrow(crafting_items))
    )

    optimize!(model)
    println(solution_summary(model))

    println("NAME", " " ^ 21, ":: ", "AMOUNT")
    
    for material ∈ eachrow(crafting_items)
        amount = value(x[material["name"]])
        if amount > 0
            println(rpad(material["name"], 25), ":: ", amount)
        end
    end
end

for item ∈ eachrow(superstitious_items)
    println("\n=== [ COMPUTING RECIPE FOR ", item["name"], " ] ===")
    solve_coeff(item)
end