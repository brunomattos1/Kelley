using Kelley
function g1(x::Vector{Float64})
    z=x[1]^2+(x[2]^2)/4-1 # PRIMEIRA RESTRIÇÃO
    return z
end

function g2(x::Vector{Float64})
    z=(x[1]^2)/4+x[2]^2-1 # SEGUNDA RESTRIÇÃO
    return z
end

@testset "Basic tests" begin
    
end