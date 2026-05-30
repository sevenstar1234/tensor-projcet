using Singular
using Dates

println("======================================")
println(" W3 tensor W4 Rank-8 Obstruction Test ")
println("======================================")

# =====================================================
# Global timer start
# =====================================================

global_start = time()

# =====================================================
# Memory helper
# =====================================================

function memory_mb()
    return round(Sys.maxrss() / 1024^2, digits=2)
end

println("\n[1/6] Initializing...")
println("Initial RAM usage: $(memory_mb()) MB")

# =====================================================
# Finite field
# =====================================================

println("\n[2/6] Creating finite field...")

F, α = Singular.FiniteField(101, 1, "a")

println("Finite field created.")

# =====================================================
# Polynomial ring
# =====================================================

println("\n[3/6] Creating polynomial ring...")

R, (
    l1,l2,l3,l4,l5,l6,l7,l8,
    b1,b2,b3,b4,b5,b6,b7,b8,
    d1,d2,d3,d4,d5,d6,d7,d8
) =

Singular.polynomial_ring(
    F,
    [
        "l1","l2","l3","l4","l5","l6","l7","l8",
        "b1","b2","b3","b4","b5","b6","b7","b8",
        "d1","d2","d3","d4","d5","d6","d7","d8"
    ],
    ordering = :degrevlex
)

println("Polynomial ring created.")
println("Current RAM usage: $(memory_mb()) MB")

# =====================================================
# Equations
# =====================================================

println("\n[4/6] Building equations...")

eqs = [

    # x0^3 y0^4 coefficient = 0
    l1 + l2 + l3 + l4 + l5 + l6 + l7 + l8,

    # x0^3 y0^3 y1 coefficient = 0
    4*l1*d1
    + 4*l2*d2
    + 4*l3*d3
    + 4*l4*d4
    + 4*l5*d5
    + 4*l6*d6
    + 4*l7*d7
    + 4*l8*d8,

    # x0^2 x1 y0^4 coefficient = 0
    3*l1*b1
    + 3*l2*b2
    + 3*l3*b3
    + 3*l4*b4
    + 3*l5*b5
    + 3*l6*b6
    + 3*l7*b7
    + 3*l8*b8,

    # target coefficient = 1
    12*l1*b1*d1
    + 12*l2*b2*d2
    + 12*l3*b3*d3
    + 12*l4*b4*d4
    + 12*l5*b5*d5
    + 12*l6*b6*d6
    + 12*l7*b7*d7
    + 12*l8*b8*d8
    - 1,

    # high-degree obstruction
    l1*b1^3*d1^4
    + l2*b2^3*d2^4
    + l3*b3^3*d3^4
    + l4*b4^3*d4^4
    + l5*b5^3*d5^4
    + l6*b6^3*d6^4
    + l7*b7^3*d7^4
    + l8*b8^3*d8^4

]

println("Equations constructed.")
println("Number of equations: $(length(eqs))")

# =====================================================
# Ideal
# =====================================================

println("\n[5/6] Constructing ideal...")

I = Singular.Ideal(R, eqs)

println("Ideal constructed.")
println("Current RAM usage: $(memory_mb()) MB")

# =====================================================
# Groebner basis computation
# =====================================================

println("\n[6/6] Computing Groebner basis...")
println("--------------------------------------")
println("This may take a LONG time.")
println("--------------------------------------")

gb_start = time()

G = std(I)

gb_end = time()

println("\nGroebner basis computation finished.")

# =====================================================
# Result check
# =====================================================

println("\n======================================")
println(" RESULT ")
println("======================================")

s = string(G)

if occursin("(1)", s)

    println("Contradiction detected.")
    println("")
    println("The Groebner basis contains:")
    println("    (1)")
    println("")
    println("Therefore:")
    println("    I = (1)")
    println("")
    println("Hence the polynomial system")
    println("has NO solution.")

else

    println("No contradiction detected.")

end

# =====================================================
# Performance summary
# =====================================================

global_end = time()

println("\n======================================")
println(" PERFORMANCE SUMMARY ")
println("======================================")

println(
    "Groebner basis time : ",
    round(gb_end - gb_start, digits=3),
    " seconds"
)

println(
    "Total execution time: ",
    round(global_end - global_start, digits=3),
    " seconds"
)

println(
    "Final RAM usage     : ",
    memory_mb(),
    " MB"
)

println("======================================")

println("\nDone.")