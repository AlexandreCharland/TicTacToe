using AbstractTrees
using StaticArrays

if !isdefined(Base, :isnothing)
    using AbstractTrees: isnothing
end

mutable struct AVLNode{T}
    data::T
    key::Int64
    parent::Union{Nothing,AVLNode{T}}
    left::Union{Nothing,AVLNode{T}}
    right::Union{Nothing,AVLNode{T}}
    height::Int8
    function AVLNode{T}(data, key, parent=nothing, l=nothing, r=nothing, h=nothing) where T
        new{T}(data, key, parent, l, r,0)
    end
end
AVLNode(data, key) = AVLNode{typeof(data)}(data, key)

#example
function leftchild!(parent::AVLNode, data, key)
    isnothing(parent.left) || error("left child is already assigned")
    node = typeof(parent)(data, key, parent)
    parent.left = node
end
function rightchild!(parent::AVLNode, data, key)
    isnothing(parent.right) || error("right child is already assigned")
    node = typeof(parent)(data, key, parent)
    parent.right = node
end

#Don't delete this
function AbstractTrees.children(node::AVLNode)
    if isnothing(node.left) && isnothing(node.right)
        ()
    elseif isnothing(node.left) && !isnothing(node.right)
        (node.right,)
    elseif !isnothing(node.left) && isnothing(node.right)
        (node.left,)
    else
        (node.left, node.right)
    end
end
AbstractTrees.nodevalue(n::AVLNode) = n.data
AbstractTrees.ParentLinks(::Type{<:AVLNode}) = StoredParents()
AbstractTrees.parent(n::AVLNode) = n.parent
AbstractTrees.NodeType(::Type{<:AVLNode{T}}) where {T} = HasNodeType()
AbstractTrees.nodetype(::Type{<:AVLNode{T}}) where {T} = AVLNode{T}

#Proof of concept
function CreateAVLTree()
    return AVLNode(MVector{5,Int8}(5,-1,1,0,3),8601)
end