### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 2f8ea1f6-53fe-11ec-3349-f9ca58bf0dc4
begin
	import Pkg
	Pkg.activate("../env")
	Pkg.instantiate()
	using Images, ImageMorphology, ColorVectorSpace, PaddedViews, TestImages
	using PlutoUI, HypertextLiteral, FileIO
	using Statistics, Noise, Plots, Random
	using Interpolations, CoordinateTransformations
end

# ╔═╡ ef57aa60-d6c2-4ec8-8500-560e88a1cd6b
img = Gray.(imresize(load("../assets/simple.png"), (256, 256)))

# ╔═╡ 95a139b5-d513-4732-91ea-22c2ff6567c6
typeof(img)

# ╔═╡ 85743935-5792-4616-9e99-23dc3cad1edb
channelview(img)

# ╔═╡ 01e8f006-0411-47e4-8b48-b8cbfa463af6
md"""
---
#### Effect of noise parameters on images
"""

# ╔═╡ 9838d227-7c49-4688-b088-691139b6c03e
md"""
##### Standard deviation ($0$ to $0.5$)
"""

# ╔═╡ 85f9fb71-c029-4eaf-87cb-cffd3833976c
@bind σ Slider(0:0.01:0.5, show_value=true)

# ╔═╡ 3951aef0-0811-4c4b-a882-67891c0af59f
md"""
##### Mean ($0$ to $0.5$)
"""

# ╔═╡ 7d97f058-9294-4df2-aff8-9c76a8209c13
@bind μ Slider(0:0.01:0.5, show_value=true)

# ╔═╡ 853b3491-88a7-41f9-8058-e529ea571b52
let
	_rand = x -> randn(size(x))
	noise = Gray.(σ .* _rand(img) .+ μ)
	noisy_img = img + noise
	histogram(vec(gray.(noisy_img)), bins=100)
	# hist_original 	= histogram(vec(gray.(img)), bins=80);
	# hist_noisy 		= histogram(vec(gray.(noisy_img)), bins=80);
	# plot(
	# 	hist_original, 
	# 	hist_noisy,
	# 	layout = (1, 2), 
	# 	legend = false, 
	# 	size=(2000,800),
	# 	title=["Original image" "Gaussian noise"]
	# )
end;

# ╔═╡ bdf85d7c-659d-40d7-8e77-310a4765ebad
begin
	noisy_img = add_gauss(img, σ, μ)
	[img noisy_img]
end;

# ╔═╡ aa472970-ec5f-4ecd-8803-fbffbe74eca7
let
	hist_noisy = histogram(vec(gray.(noisy_img)), bins=200);
	plot(
		hist_noisy,
		legend = false, 
		size=(1000,800),
		xticks = 0:0.05:1
	)	
end

# ╔═╡ 8c202be9-2f5f-4ef6-9c98-f1c18a45a739
# begin
# 	hist_original 	= histogram(vec(gray.(img)), bins=80);
# 	hist_noisy 		= histogram(vec(gray.(noisy_img)), bins=80);
# 	plot(
# 		hist_original, 
# 		hist_noisy,
# 		layout = (1, 2), 
# 		legend = false, 
# 		size=(2000,800),
# 		title=["Original image" "Gaussian noise"]
# 	)
# end

# ╔═╡ a1d21845-a7c1-4ae6-84f5-2fd56fd02d81
let 
	hist_noisy = histogram(vec(gray.(img)), bins=255);
end

# ╔═╡ fd0f6307-4703-406c-93b4-053ee53a9c7e
let 
	hist_noisy = histogram(vec(gray.(noisy_img)), bins=80);
end

# ╔═╡ 731d4d5a-5e6d-40b1-a70c-551a78aa34b4
begin
	uniform_noise = rand(Gray{Normed{UInt8,8}}, (256, 256)) .* 0.2
	uniform_noise_img = img .+ uniform_noise
	hist_uniform_noise	= histogram(vec(gray.(uniform_noise_img)), bins=100)
end

# ╔═╡ 58e0d138-b1c5-450a-be62-f05fe92b86c0
begin
	exp_noise = Gray.(randexp((256, 256)) * 0.1)
	exp_noise_img = img .+ exp_noise
	histogram(vec(gray.(exp_noise_img)), bins=100)
end

# ╔═╡ 32008049-5c7c-48b8-96b0-9dc4af9f43a9
begin
	gaus_noise = Gray.(randn((256, 256)) * 0.05)
	gaus_noise_img = img .+ gaus_noise
	histogram(vec(gray.(gaus_noise_img)), bins=100)
end

# ╔═╡ Cell order:
# ╠═2f8ea1f6-53fe-11ec-3349-f9ca58bf0dc4
# ╠═ef57aa60-d6c2-4ec8-8500-560e88a1cd6b
# ╠═95a139b5-d513-4732-91ea-22c2ff6567c6
# ╠═85743935-5792-4616-9e99-23dc3cad1edb
# ╟─01e8f006-0411-47e4-8b48-b8cbfa463af6
# ╟─9838d227-7c49-4688-b088-691139b6c03e
# ╠═85f9fb71-c029-4eaf-87cb-cffd3833976c
# ╟─3951aef0-0811-4c4b-a882-67891c0af59f
# ╠═7d97f058-9294-4df2-aff8-9c76a8209c13
# ╟─853b3491-88a7-41f9-8058-e529ea571b52
# ╠═bdf85d7c-659d-40d7-8e77-310a4765ebad
# ╠═aa472970-ec5f-4ecd-8803-fbffbe74eca7
# ╠═8c202be9-2f5f-4ef6-9c98-f1c18a45a739
# ╠═a1d21845-a7c1-4ae6-84f5-2fd56fd02d81
# ╠═fd0f6307-4703-406c-93b4-053ee53a9c7e
# ╠═731d4d5a-5e6d-40b1-a70c-551a78aa34b4
# ╠═58e0d138-b1c5-450a-be62-f05fe92b86c0
# ╠═32008049-5c7c-48b8-96b0-9dc4af9f43a9
