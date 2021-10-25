### A Pluto.jl notebook ###
# v0.16.4

using Markdown
using InteractiveUtils

# ╔═╡ 252867c0-3495-11ec-0b19-b7c74b40fb64
begin
	import Pkg
	Pkg.activate("../env")
	Pkg.instantiate()
	
	using Images, ImageMorphology, ColorVectorSpace, PaddedViews, TestImages, FileIO
	using PlutoUI, HypertextLiteral
	using Statistics, Plots, FFTW, Hadamard
	using Interpolations, CoordinateTransformations
end

# ╔═╡ 7c2efd84-e514-4dd2-88cc-27f8c007e922
md"""
### Frequency domain filtering
"""

# ╔═╡ ff64eb4b-a69b-43f1-aa66-8f729770108f
md"""
### Walsh-Hadamard transform
The Hadamard transform (also known as the Walsh–Hadamard transform, Hadamard–Rademacher–Walsh transform, Walsh transform, or Walsh–Fourier transform) is an example of a generalized class of Fourier transforms.

The Hadamard transform can be regarded as being built out of size-2 discrete Fourier transforms (DFTs), and is in fact equivalent to a multidimensional DFT of size 2 × 2 × ⋯ × 2 × 2.

The output are real values between -1 and 1
"""

# ╔═╡ ee8c1661-624d-46a8-934e-66b97dc73723
begin
	img = testimage("mandrill")
	imresize(img, ratio=0.6)
end

# ╔═╡ 21cf4bdc-1810-4c00-92b4-5384b2316fae
md"""
Apply the forward walsh transform
"""

# ╔═╡ 25d0c748-c79a-48a9-9165-4d3acd128321
wh = fwht(Float64.(Gray.(img)));

# ╔═╡ f496adb3-8884-48c6-8c2d-ba4ccd5e5b55
md"""

The dynamic range of the Walsh coefficients is too large to display
So we apply a log-transformation to the magnitude to the values to visualise them better.

"""

# ╔═╡ 02c47a24-e09c-4c00-b2c1-a6616adfd5ed
heatmap(wh)

# ╔═╡ b9111235-2396-40ba-a108-4293c11cfa2b
heatmap(log.((512) .* abs.(wh)))

# ╔═╡ b3165a79-b771-4f74-b829-419dbe6d0ba7
md"""
##### Low pass filtering (Image smoothing)
"""

# ╔═╡ 13f1e62e-238d-4b99-9418-33fceaeb6ffb
md"""
Set all frequencies above cut-off frequency to 0
"""

# ╔═╡ 3ecc5344-f89e-42bd-b4be-9907ac5dd72c
load("../assets/low-pass.png")

# ╔═╡ f39d58be-609f-46fc-ae75-abae656fb5e9
let
	wh_low_pass = copy(wh)
	
	width, height = size(img)
	
	radius = 150
	
	for x in 1:width
		for y in 1:height
			if sqrt(x^2 + y^2) <= radius
				wh_low_pass[x, y] = wh_low_pass[x, y] .* 1
			else
				wh_low_pass[x, y] = wh_low_pass[x, y] .* 0
			end
		end
	end
	
	filtered = ifwht(wh_low_pass)
	[Gray.(img) Gray.(filtered)]
end

# ╔═╡ cabcd05a-f011-4fa9-89f2-580284129822
md"""
---
"""

# ╔═╡ 21691ffe-5bdf-484e-af3c-0de673d42832
md"""
##### High pass filtering (Image sharpening)
Set all frequencies below cut-off frequency to 0
"""

# ╔═╡ e95631d8-92f7-4a90-8e0c-a8c47ad0524f
load("../assets/high-pass.png")

# ╔═╡ ccb72855-e76e-4c80-beb6-a5af27c2b0ea
let
	wh_low_pass = copy(wh)
	
	width, height = size(img)
	
	radius = 80
	
	# 
	for x in 1:width
		for y in 1:height
			if sqrt(x^2 + y^2) <= radius
				wh_low_pass[x, y] = wh_low_pass[x, y] .* 0
			else
				wh_low_pass[x, y] = wh_low_pass[x, y] .* 1
			end
		end
	end
	
	filtered = ifwht(wh_low_pass)
	[Gray.(img) Gray.(filtered)]
end

# ╔═╡ c99b2b93-b408-43f1-b044-4285b9f71b29
md"""
---
"""

# ╔═╡ 5c82f624-24fd-469d-8e2c-af99dc5e1612
md"""
#### Visualising the walsh coefficients
As we can see, the DC component has the highest coefficient among all frequencies
"""

# ╔═╡ 751dc9af-b476-4e03-a6f0-d879ab17b63b
begin
	
	transformed_wh_n = sqrt.(512 .* abs.(wh))
	
	# plot the first row 	
	X = 1:512 					
	Y = 1 .* ones(512) 
	z = transformed_wh_n[1, :]
	
	p = plot3d(X, Y, z, legend=false, camera=(20, 5))
	
	for i in 2:512
		# plot each row in the matrix 		
		# coordinates will be (i, 1), (i, 2), (i, 3) ... 
		X = 1:512 					
		Y = i .* ones(512) 
		z = transformed_wh_n[i, :]
		plot3d!(X, Y, z)
	end
	
	# show plot
	p
end

# ╔═╡ Cell order:
# ╟─7c2efd84-e514-4dd2-88cc-27f8c007e922
# ╠═252867c0-3495-11ec-0b19-b7c74b40fb64
# ╟─ff64eb4b-a69b-43f1-aa66-8f729770108f
# ╠═ee8c1661-624d-46a8-934e-66b97dc73723
# ╟─21cf4bdc-1810-4c00-92b4-5384b2316fae
# ╠═25d0c748-c79a-48a9-9165-4d3acd128321
# ╟─f496adb3-8884-48c6-8c2d-ba4ccd5e5b55
# ╠═02c47a24-e09c-4c00-b2c1-a6616adfd5ed
# ╠═b9111235-2396-40ba-a108-4293c11cfa2b
# ╟─b3165a79-b771-4f74-b829-419dbe6d0ba7
# ╟─13f1e62e-238d-4b99-9418-33fceaeb6ffb
# ╠═3ecc5344-f89e-42bd-b4be-9907ac5dd72c
# ╠═f39d58be-609f-46fc-ae75-abae656fb5e9
# ╟─cabcd05a-f011-4fa9-89f2-580284129822
# ╠═21691ffe-5bdf-484e-af3c-0de673d42832
# ╟─e95631d8-92f7-4a90-8e0c-a8c47ad0524f
# ╠═ccb72855-e76e-4c80-beb6-a5af27c2b0ea
# ╟─c99b2b93-b408-43f1-b044-4285b9f71b29
# ╟─5c82f624-24fd-469d-8e2c-af99dc5e1612
# ╠═751dc9af-b476-4e03-a6f0-d879ab17b63b
