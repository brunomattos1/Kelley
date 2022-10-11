module Kelley

struct KelleyAlgorithm end

using JuMP
import HiGHS
using LinearAlgebra
using ForwardDiff

export optimize!, KelleyAlgorithm

function cut(
    gi_x̄::Float64, ∇gi_x̄::Vector{Float64}, x̄::Vector{Float64}, x::Vector{VariableRef}
) 
    return gi_x̄ + ∇gi_x̄⋅(x - x̄) # para criar x como variavel, devemos definir em @variables
end

function JuMP.optimize!(
    ::KelleyAlgorithm, f::Function, g::Function, n::Int;
    Jg = x -> ForwardDiff.jacobian(g,x), lb = -1e6, ub = 1e6
)
    m = length(g(zeros(Float64, n)))
    model = Model(HiGHS.Optimizer)
    set_silent(model)
    @variable(model, lb <= x[1:n] <= ub)
    @objective(model, Min, f(x))
    stop = false
    while !stop
        optimize!(model)
        x̄ = JuMP.value.(x)
        g_x̄ = g(x̄)
        Jg_x̄ = Jg(x̄)
        stop = true
        for i in 1:m
            if g_x̄[i] >= 1e-6
                @constraint(model,cut(g_x̄[i], Jg_x̄[i,:], x̄, x) <= 0)
                stop = false
            end
        end
    end
    println("Objective value: ",objective_value(model))
    print("Solution: ", value.(x))
end

end