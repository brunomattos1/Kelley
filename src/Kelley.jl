module Kelley

struct KelleyAlgorithm end

using JuMP
import HiGHS
using LinearAlgebra
using ForwardDiff

export optimize!, show_objective, show_solution, show_model, KelleyAlgorithm

function cut(
    gi_x̄::Float64, ∇gi_x̄::Vector{Float64}, x̄::Vector{Float64}, x::Vector{VariableRef}) 
    return gi_x̄ + ∇gi_x̄⋅(x - x̄)
end

function JuMP.optimize!(
    ::KelleyAlgorithm, f::Function, g::Function, n::Int;lb = fill(-1e6,n), ub = fill(1e6,n),
        Jg = x -> ForwardDiff.jacobian(g,x))
    
    m = length(g(zeros(Float64, n)))
    global model=Model(HiGHS.Optimizer)
    set_silent(model)
    @variable(model, lb[i] <= x[i in 1:n] <= ub[i])
    @objective(model, Min, f(x))
    stop = false
    while !stop
        optimize!(model)
        global x̄ = JuMP.value.(x)
        g_x̄ = g(x̄)
        Jg_x̄ = Jg(x̄) 
        stop = true
        
        # cut deletion
        if num_constraints(model, AffExpr, MOI.LessThan{Float64})>=10000
            println("Over 10000 constraints")
            cons=all_constraints(model, GenericAffExpr{Float64, VariableRef}, MOI.LessThan{Float64})
            eval_constraints=value.(cons)
            indice_smallest=sortperm(eval_constraints)[1:3000]
            delete.(model, cons[indice_smallest])
        end
        
        # cut add
        for i in 1:m
            if g_x̄[i]>=1e-6
                @constraint(model,cut(g_x̄[i], Jg_x̄[i,:], x̄,x) in MOI.LessThan(0.0))
                stop = false
            end
        end
    end
    global obj=objective_value(model)
    global model_=model
    print("Done!")
end

function show_objective()
    return obj
end

function show_solution()
    return x̄
end

function show_model()
    return model_
end

end