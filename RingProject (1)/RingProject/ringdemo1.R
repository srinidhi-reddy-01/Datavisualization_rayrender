library(rayrender)
library(jpeg)
library(magick)
library(imager)

#taking the image and storing ina array format
image_array <- readJPEG("ring1.jpeg")


#generating ground with zero depth and smokey white in color
#then adding the image array to the ground and with proper dimensions and orientation
#adding one light source
#next are four cube for reference
scene = generate_ground(depth=0,
                         material = diffuse(color= "#F5F5F5")) %>%
   add_object(yz_rect(x=0,y=0,z=0,zwidth=30,ywidth=30,
                      material = diffuse(image = image_array),angle=c(-90,0,-90))) %>%
   add_object(sphere(x=60,y=60,z=-60,radius=20,material=light(intensity = 8)))%>%
    add_object(cube(x=4,y=4,z=4,material=lambertian(color="red")))%>%
    add_object(cube(x=4,y=4,z=-4,material=lambertian(color="blue")))%>%
    add_object(cube(x=-4,y=4,z=4,material=lambertian(color="green")))%>%
    add_object(cube(x=-4,y=4,z=-4,material=lambertian(color="yellow")))
 


#next few lines are again generating new groung,image array and
#moving the SUN diagonally
#you can uncomment it
a=12

xanglight=0
yanglight=60*sin(10*(a-1)*pi/360)
zanglight=60*cos(10*(a-1)*pi/360)
# scene = generate_ground(depth=0,
#                         material = diffuse(color= "#F5F5F5")) %>%
#   add_object(yz_rect(x=0,y=0,z=0,zwidth=30,ywidth=30,
#                      material = diffuse(image = image_array),angle=c(-90,0,-90))) %>%
#   add_object(sphere(x=xanglight,y=yanglight,z=zanglight,radius=20,material=light(intensity = 20)))



#this are camera vectors
xfrom=20
yfrom=50
zfrom=0

xat=0
yat=0
zat=0

#this line will render the generated scene with given size
render_scene(scene,fov=20, width=500, height=500, samples=1000,
             lookfrom=c(xfrom,yfrom,zfrom),parallel=TRUE)


#this loop will generate 37 images with different SUN position

for(a in 1:37){
  xanglight=0
  yanglight=60*sin(10*(a-1)*pi/360)
  zanglight=60*cos(10*(a-1)*pi/360)
  scene = generate_ground(depth=0,
                          material = diffuse(color= "#F5F5F5")) %>%
    add_object(yz_rect(x=0,y=0,z=0,zwidth=30,ywidth=30,
                       material = diffuse(image = image_array),angle=c(-90,0,-90))) %>%
    add_object(sphere(x=xanglight,y=yanglight,z=zanglight,radius=20,material=light(intensity = 20)))
  
  rem = a%%100-a%%10
  
  if(rem == 0){
    name<-paste("images/plota",a,".png")
  }else if(rem == 10){
    name<-paste("images/plotb",a,".png")
  }else if(rem == 20){
    name<-paste("images/plotc",a,".png")
  }else if(rem == 30){
    name<-paste("images/plotd",a,".png")
  }
  
  # for saving images in image folder of the directory
  png(filename=name)
  render_scene(scene,fov=20, width=500, height=500, samples=1000,
               lookfrom=c(xfrom,yfrom,zfrom),parallel=TRUE)
  dev.off()
}


#the code below will join the images and set the framerate
## list file names and read in
imgs <- list.files("images", full.names = TRUE)
img_list <- lapply(imgs, image_read)

## join the images together
img_joined <- image_join(img_list)

## animate at 2 frames per second
img_animated <- image_animate(img_joined, fps = 10)

## view animated image
img_animated

## save to disk
image_write(image = img_animated,
            path = "ring9.gif")
