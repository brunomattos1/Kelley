# Kelley
Kelley is a Julia package that uses an acceleration of cutiing planes method created by J. E. Kelley, Jr. to solve convex optimization problem with linear objective function. Also, this package uses the HiGHS Optimizer for Linear Programming, from JuMP.

### Installation import
julia> Pkg.add("https://github.com/brunomattos1/Kelley.git")

julia> import Kelley

julia> using Kelley

### How the Kelley Cutting Plane algorithm works
Let $f(x)$ be the objective function and $G_i(x)$ the constraints (convex). Let $S_0$ be an hypercube, such that $G_i(x) \leqslant 0 \subset S_0, \ \forall i$. 

Then, minimize $f(x)$ in $S_0$. 

Let $t_1$ be the solution. Compute the the cut $p_i(x;t_1)=G_i(t_1)+\nabla G_i(t_1)\cdot (x-t_1), \ \forall i$, and set $S_1=S_0 \cap p_i(x;t_1) \leqslant 0$.

Now, minimize $f(x)$ in $S_1$.

Repeat, until $G(t_k) \leqslant 10^{-6}$

**Remark 1:** The subproblems minimization ( $f(x)$ in $S_i$ ) is a linear programming problem, since $f(x)$ is linear and $S_i$ is polytope.

**Remark 2:** The algorithm creates a cut for each violated constraint, instead of creating only one cut, for the most violated constraint, as Kelley proposed.

### How to use the package

You must create your constraints functions as a unique function $$g: \mathbb{R}^n \rightarrow{} \mathbb{R}^m$$ In Julia code, would be $$g(x)=[g_1(x),g_2(x),\dots,g_n(x)]$$ where $g_i(x)$ are the constraints of the problem, and $x$ is a vector.

And your objective function $$f(x)=c \cdot x$$ always linear. Both $g(x)$ and $f(x)$ must have generic arguments. If your objective function is non linear, use the epigraph form instead.

The call of the function is given by 
```julia
optimize!(KelleyAlgorithm(), f, g, number of variables, lb, ub)
```
Where lb and ub are lower and upper bounds of the variables. You must pass the bounds as a vector of floats, e.g, lb=[0.0, 1.0], ub=[2.3, 3.14]. As default, the bounds are set to be -1e6 and 1e6.

The output gives the objective value and the approximated optimal solution.

The stop criterion is the following:

Let $x_k$ be a solution. If $g_i(x_k) \leqslant 10^{-6}, \ \forall i$, stop, we found an optimal solution. (criterion guaranteed by the convergence theorem)

### Example
Let $$f(x,y)=x-y$$ and the constraints: $$g_1(x,y)=x^2 + \dfrac{y^2}{4} - 1$$ $$g_2(x,y)=\dfrac{x^2}{4} + y^2 - 1$$
In Julia, it is written as follows:

```julia
f(x)=return x[1]-x[2]

g(x)=return[
  x[1]^2 + (x[2]^2)/4 - 1, #first constraint 
  x[1]^2/4 + x[2]^2 - 1 #second constraint
  ] 
```
Then, we call the function using the lower bound and upper bound as default.
```julia
optimize!(KelleyAlgorithm(),f,g,2)
```
Getting the following result
```julia
(-1.5970674466118795, [-0.7936493370308374, 0.8034181095810422])
```

