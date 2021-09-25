### A Pluto.jl notebook ###
# v0.16.0

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 489508d5-4f06-48ca-8732-bfb9b171a5e3
begin
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
		"ColorVectorSpace",
		"CoordinateTransformations",
		"Images",
		"ImageMorphology",
		"ImageIO", 
		"Interpolations",
		"FileIO",  
		"PlutoUI", 
		"PNGFiles",
		"HypertextLiteral",
		"TestImages",
		"Statistics",
		"PaddedViews",
		"ImageFiltering"
	])
	using Images, ImageMorphology, ColorVectorSpace, PaddedViews, TestImages, FileIO
	using PlutoUI
	using HypertextLiteral
	using Statistics
	using Interpolations, CoordinateTransformations
end

# ╔═╡ 8f18fa10-1dce-11ec-31a1-794371cd065c
@bind a Slider(1:10, show_value=true)

# ╔═╡ 44b4934d-ae46-4ae7-bdf4-5ae746f4b6d8
a * 10

# ╔═╡ Cell order:
# ╠═489508d5-4f06-48ca-8732-bfb9b171a5e3
# ╠═8f18fa10-1dce-11ec-31a1-794371cd065c
# ╠═44b4934d-ae46-4ae7-bdf4-5ae746f4b6d8
