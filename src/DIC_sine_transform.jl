using PyPlot, Images
using PyCall
@pyimport numpy

function DIC_sine_transform(img_name, lambda)

    # load in RGB data, convert to greyscale array
    raw_img = PyPlot.imread(img_name);
    img = convert(Image{Images.Gray},raw_img[:,:,1:3]);
    M = convert(Array,img);
    M = float(M); 

    # take gradient of image, then process
    gX, gY = numpy.gradient(M);   
    d1 = FFTW.r2r(gY,FFTW.RODFT00)
    nx, ny = size(d1)
    d3=zeros(nx,ny)
    d3=[(nx/pi)^2 * d1[j,i]/(lambda*j^2 + i^2) for i in 1:nx, j in 1:ny];
    dst = convert(Array{Float64,2},d3)
    e1 = FFTW.r2r(dst,FFTW.RODFT00)
    e1 = e1 / (2*nx)^2

    # clamp image range to 0 1, output as .png
    maxi = maximum(e1)
    mini = minimum(e1)
    clamped = 1 +  (-e1 + maxi) * 1 / ( mini-maxi);
    out_name = split(image_name,".")[1] * "_sin_l=$(@sprintf("%.2f", lambda))" * ".png"
    imwrite(grayim(clamped),out_name)
    
    return clamped
    
end
