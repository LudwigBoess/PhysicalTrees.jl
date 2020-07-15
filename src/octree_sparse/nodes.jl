struct TopNode{I<:Integer}
    Daughter::I
    Pstart::I
    Blocks::I
    Leaf::I
    Size::Int128
    StartKey::Int128
    Count::Int128
end
TopNode(;bits=21) = TopNode(-1, 1, 0, 0, Int128(1)<<(3*bits), Int128(0), Int128(0))
@inline length(p::T) where T <: TopNode = 1

#=
struct OctreeNode2D{I<:Integer} <: AbstractOctreeNode2D{I}
    ID::I
    Father::I
    DaughterID::Array{I,1}
    Center::AbstractPoint2D
    SideLength::Number
    Mass::Number
    MassCenter::AbstractPoint2D
    MaxSoft::Number
    SparseDaughterID::Array{I,1} # Walk in sparse tree to improve performance
    PDM_Mass::Number
    PDM_MassCenter::AbstractPoint2D
    IsLeaf::Bool
    ParticleID::I # Refers to the particle on this leaf.
                      # One leaf can only take one particle. Set 0 if none or more than 1

    NextNode::I
    Sibling::I
    BitFlag::I
end

OctreeNode2D() = OctreeNode2D(1, 0, [0,0,0,0,0,0,0,0], PVector(u"kpc"), 0.0u"kpc", 0.0u"Msun",
                        PVector(u"kpc"), 0.0u"kpc", Array{Int64,1}(), 0.0u"Msun", PVector(u"kpc"), true, 0, 0, 0, 0)
=#

struct OctreeNode{I<:Integer, C, L, M} <: AbstractOctreeNode{I}
    ID::I
    Father::I
    DaughterID::MArray{Tuple{8},I,1,8}
    Center::C
    SideLength::L
    Mass::M
    MassCenter::C
    MaxSoft::L
    IsLeaf::Bool
    ParticleID::I # Refers to the particle on this leaf.
                      # One leaf can only take one particle. Set 0 if none or more than 1

    NextNode::I
    Sibling::I
    BitFlag::I
end

OctreeNode(::Nothing) = OctreeNode(1, 0, MArray{Tuple{8}}([0,0,0,0,0,0,0,0]), PVector(), 0.0, 0.0,
                        PVector(), 0.0, true, 0, 0, 0, 0)

function OctreeNode(u::Array)
    uLength = getuLength(u)
    uMass = getuLength(u)
    return OctreeNode(1, 0, MArray{Tuple{8}}([0,0,0,0,0,0,0,0]), PVector(uLength), 0.0uLength, 0.0uMass,
                        PVector(uLength), 0.0uLength, true, 0, 0, 0, 0)
end


struct DomainNode{C, V, M, L, B}
    MassCenter::C
    Vel::V
    Mass::M
    MaxSoft::L
    BitFlag::B # Int
end

DomainNode(::Nothing) = DomainNode(PVector(), PVector(), 0.0, 0.0, 0)

function DomainNode(u::Array)
    uLength = getuLength(u)
    uTime = getuTime(u)
    uMass = getuLength(u)
    DomainNode(PVector(uLength), PVector(uLength / uTime), 0.0uMass, 0.0uLength,0)
end


struct ExtNode{L, V}
    hmax::L
    vs::V  # Center-of-mass velocity
end
ExtNode(::Nothing) = ExtNode(0.0, PVector())
ExtNode(u::Array) = ExtNode(0.0 * getuLength(u), PVector(getuLength(u) / getuTime(u)))