"""
    PowerGeneralizedWeibull(sigma,nu,gamma)

The *PowerGeneralizedWeibull distribution* with scale `sigma`, shape `nu` and second shape `gamma` has probability density function 

```math
f(x; parameters) = ...
```

More details and examples of usage could be provided in this docstring.

Maybe this distribution could simply be constructed from a transformation of the original Weibull ? 

References: 
* [Link to my reference so that people understand what it is](https://myref.com) 
"""
struct PowerGeneralizedWeibull{T<:Real} <: Distributions.ContinuousUnivariateDistribution
    sigma::T
    nu::T
    gamma::T
    function PowerGeneralizedWeibull(sigma,nu,gamma)
        T = promote_type(Float64, eltype.((sigma,nu,gamma))...)
        return new{T}(T(sigma), T(nu), T(gamma))
    end
end
PowerGeneralizedWeibull() = PowerGeneralizedWeibull(1,1,1)
Distributions.params(d::PowerGeneralizedWeibull) = (d.sigma,d.nu,d.gamma)

Distributions.@distr_support PowerGeneralizedWeibull 0.0 Inf

function Distributions.rand(rng::AbstractRNG, d::PowerGeneralizedWeibull)
    return d.sigma * ((1 - log(1 - Base.rand(rng))) ^ d.gamma - 1) ^ (1 / d.nu)
end
function Distributions.logpdf(d::PowerGeneralizedWeibull, t::Real)
    return log(d.nu) - log(d.gamma) - d.nu * log(d.sigma) + (d.nu - 1) * log(t) +
    (1 / d.gamma - 1) * log(1 + (t / d.sigma) ^ d.nu) +
    (1 - (1 + (t / d.sigma) ^ d.nu) ^ (1 / d.gamma))
end
function Distributions.logccdf(d::PowerGeneralizedWeibull, t::Real)
    return 1 - (1 + (t / d.sigma) ^ d.nu) ^ (1 / d.gamma)
end
Distributions.ccdf(d::PowerGeneralizedWeibull, t::Real) = exp(Distributions.logccdf(d,t))
Distributions.cdf(d::PowerGeneralizedWeibull, t::Real) = 1 - Distributions.ccdf(d,t)
function Distributions.quantile(d::PowerGeneralizedWeibull, p::Real)
    return d.sigma * ((1 - log(1 - p)) ^ d.gamma - 1) ^ (1 / d.nu)
end