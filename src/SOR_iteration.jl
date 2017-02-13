@acc function SOR_iteration(img::Array{Float64,2},img0::Array{Float64,2}, iterations::Int, om::Float64=1.0, lambda2::Float64=0.05)
    buf = Array(Float64, size(img)...) 
    runStencil(buf, img, img0, iterations, :oob_wraparound) do b, a, c
        
        b[0,0] = (1.0-om)*a[0,0] + om*( a[0,0] + 0.15*(
                                    (-(1/12) * a[0,2] + (4/3) * a[0,1] - (5/2)*a[0,0] + (4/3) * a[0,-1] -(1/12) * a[0,-2])
                      +lambda2*     (-(1/12) * a[2,0] + (4/3) * a[1,0] - (5/2)*a[0,0] + (4/3) * a[-1,0] -(1/12) * a[-2,0])
                                   -( (1/12) * c[0,2] + (2/3) * c[0,1]                  - (2/3) * c[0,-1] -(1/12) * c[0,-2])
              ))
       return a, b, c
    end
    return img
end
