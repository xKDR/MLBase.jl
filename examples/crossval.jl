# A simple example to demonstrate the use of cross validation
#
# Here, we consider a simple model: using a mean vector to represent
# a set of samples. The goodness of the model is assessed in terms
# of the RMSE (root-mean-square-error) evaluated on the testing set
#

using MLBase

# functions

function compute_center(X::Matrix{Float64})
	c = vec(mean(X, dims = 2))
	println("training on $(size(X,2)) samples => ($(c[1]), $(c[2]))")
	return c
end

function compute_rmse(c::Vector{Float64}, X::Matrix{Float64}) 
	v = sqrt(mean(sum(abs2.(X .- c))))
	println("RMSE on test set: $v\n")
	return v
end

# data

const n = 200
const data = [2., 3.] .+ randn(2, n)

# cross validation

scores = cross_validate(
	inds -> compute_center(data[:, inds]),     		# training function
	(c, inds) -> compute_rmse(c, data[:, inds]),    # evaluation function
	n,    			# total number of samples
	Kfold(n, 5)) 	# cross validation plan: 5-fold 

# display results

print("scores :\n", scores)

