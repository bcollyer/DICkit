using PyPlot, Images
using PyCall
@pyimport numpy

function DIC_cosine_transform(img_name)

    raw_img = PyPlot.imread(img_name);
    img = convert(Image{Images.Gray},raw_img[:,:,1:3]);
    M = convert(Array,img);
    M = float(M); 
    
    mx, my = size(M)
    m1 = mean(M[:,1])
    mL = mean(M[:,end])
    
    for i=1:mx
        #M[:,i]=M[:,i] - i*(mL-m1)/my
        M[:,i] = M[:,i] - mean(M[:,i])
    end
    
    m1 = mean(M[:,1])
    mL = mean(M[:,end])   
    
    println(m1)
    println(mL)
    
    #M = [M flipdim(M[:,2:end-1],2)]
    
    println(size(M))
        
    gX, gY = numpy.gradient(M);  
    
        for i=1:mx
        #M[:,i]=M[:,i] - i*(mL-m1)/my
        gY[:,i] = gY[:,i] - mean(gY[:,i])
    end
   # gY = [gY flipdim(gY[:,2:end-1],2)];
    
    println(size(gY))
    lambda = 0.1;
    d1 = FFTW.r2r(gY,FFTW.REDFT00)
    nx, ny = size(d1)
    
    println(size(d1))
    d2=zeros(ny,nx)
    d2=[(nx/pi)^2 * d1[j,i]/(lambda*j^(1.25) + i^2) for i in 1:ny, j in 1:nx];
    #d2=[(nx/pi)^2 * d1[j,i] for i in 1:ny, j in 1:nx];
    
    dst = convert(Array{Float64,2},d2)
    e1 = FFTW.r2r(dst,FFTW.REDFT00)
    e1 = e1 / (2*nx)^2
    
    maxi = maximum(e1)
    mini = minimum(e1)
    
    clamped = 1 +  (-e1 + maxi) * 1 / ( mini-maxi);
    
    imwrite(grayim(clamped),"cosDICdan.png")
    
    return e1
    
end