using PyPlot, Images
using PyCall
@pyimport numpy

function makeDICimage(img_name="../images/mandrill.png";sigma = 0.1)


  raw_img = PyPlot.imread(img_name);
  img = convert(Image{Images.Gray},raw_img[:,:,1:3]);
  M = convert(Array,img);
  M = float(M);

  gX, gY = numpy.gradient(M);
  gY = gY + sigma*rand(size(gY));

  maxi = maximum(gY)
  mini = minimum(gY)
  clamped = 1 +  (-gY' + maxi) * 1 / ( mini-maxi);
  out_name = "../DICimages/DIC" * basename(img_name)
  imwrite(grayim(clamped),out_name)

  @printf("File outputted to ../DICimages/")
  return

end
