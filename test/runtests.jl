using Kelley, JuMP, Test, ForwardDiff

function f(x::Vector{VariableRef})
    return x[1] - x[2]
end

function g(x)
    return [
        x[1]^2 + (x[2]^2)/4 - 1, # First Constraint
        (x[1]^2)/4 + x[2]^2 - 1 # Second Constraint
    ]
end


@testset "Basic tests" begin
    obj, x̄ = optimize!(KelleyAlgorithm(), f, g, 2)
    @test obj ≈ -1.788854382
    @test x̄[1] ≈ -0.894427191
    @test x̄[2] ≈ 0.894427191
end