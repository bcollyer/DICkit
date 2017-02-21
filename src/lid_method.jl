using PyPlot, Images
using PyCall


function trapz(a)
  return sum(a) - 0.5*a[1] - 0.5*a[end]
end


function lid_method(img_name="../DICimages/DICmandrill.png")

  raw_img = PyPlot.imread(img_name);
  img = convert(Image{Images.Gray},raw_img[:,:,1:3]);
  M = convert(Array,img);
  M = float(M);
  M= M'
  M = M - mean(mean(M))
  intM = [ trapz( M[1:i,j] ) for i in 1:size(M,1), j in 1:size(M,2)]


  maxi = maximum(intM)
  mini = minimum(intM)
  clamped = 1 +  (-intM + maxi) * 1 / ( mini-maxi);
  clamped = convert(Array{Float64,2},clamped)
  out_name = "../images/LID" * basename(img_name)[4:end]
  imwrite(grayim(clamped),out_name)


  @printf("file outputted to /images/")

  return
end


function exdecay_method(img_name="../DICimages/DICmandrill.png"; s=10.0)

    raw_img = PyPlot.imread(img_name);
    img = convert(Image{Images.Gray},raw_img[:,:,1:3]);
    M = convert(Array,img);
    M = float(M);
    M= M'
    M = M - mean(mean(M))
    lx, ly = size(M)
    xrange =[ -lx+1:1:lx-1]

    lM = [ trapz( M[1:i,j]   .* exp(xrange[lx+1-i:lx]/s ) ) - trapz( M[i:end,j] .* exp(-1*xrange[lx:end+1-i]/s ) )  for i in 1:lx, j in 1:ly]
    #rM = [ trapz( M[i:end,j] .* exp(-1*xrange[lx:end+1-i]/s ) ) for i in 1:lx, j in 1:ly]

    intM =lM

    maxi = maximum(intM)
    mini = minimum(intM)
    clamped = 1 +  (-intM + maxi) * 1 / ( mini-maxi);
    clamped = convert(Array{Float64,2},clamped)
    out_name = "../images/exp" * basename(img_name)[4:end]
    imwrite(grayim(clamped),out_name)


    @printf("file outputted to /images/")

    return
  end
