PImage img;
PImage original_img;
boolean press = true;

//kernel for gaussian blur filter
float[][] kernel = {{ 0.0625, 0.125, 0.0625 }, 
                    { 0.125, .25, 0.125 }, 
                    { 0.0625, 0.125, 0.0625 }}; 

//kernel for edge detection
float[][] ver = {{-1,0,1},
                 {-2,0,2},
                 {-1,0,1}};
 
//kernel for edge detection
float[][] hor = {{-1,-2,-1},
                {0,0,0},
                {1,2,1}};

void setup() {
  surface.setResizable(true);
  img = loadImage("dogcat.png");
  original_img = loadImage("dogcat.png");
  surface.setSize(img.width, img.height);
  surface.setSize(original_img.width, original_img.height);
}

//grayscale filter, called in draw()
void grayscale() {

  img.loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {

      int loc = x + y*img.width;
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      //average out the r,g and b values to be the same value
      float avg = ((r+g+b) / 3);

      img.pixels[loc] = color(avg, avg, avg);
    }
  }
  
  img.updatePixels(); 
  image(img, 0, 0);
}


// contrast filter, called in draw()
void contrast() {
  
  img.loadPixels();
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y++) {

      int loc = x + y*img.width;
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      // 127.5 as cutoff point and anything below gets subtracted 20
      // and anything above gets added 20
      if (r >= 127.5) {
        r += 20;
      } else if (r < 127.5) {
        r -= 20;
      }
      if (g >= 127.5) {
        g += 20;
      } else if (g < 127.5) {
        g -= 20;
      }
      if (b >= 127.5) {
        b += 20;
      } else if (b < 127.5) {
        b -= 20;
      }
      img.pixels[loc] = color(r, g, b);
    }
  }
  
  img.updatePixels(); 
  image(img, 0, 0);
}


void draw() {
  image(img, 0, 0);
  
  // conditions for each button pressed, 0-4
  if (keyPressed) {
    if (key == '0') {
      img = loadImage("dogcat.png");
      original_img.copy(img, 0, 0, img.width, img.height, 0, 0, original_img.width, original_img.height);
      press = true;
    }
  } else if (key == '1') {
    img = loadImage("dogcat.png");
    original_img.copy(img, 0, 0, img.width, img.height, 0, 0, original_img.width, original_img.height);
    grayscale();
    press = true;
    
    
    // the boolean allows me to make the program run through only one time 
    // so it doesnt contrast all the way until it becomes a black and white image
  } else if ((key == '2') && (press == true)) {
    img = loadImage("dogcat.png");
    original_img.copy(img, 0, 0, img.width, img.height, 0, 0, original_img.width, original_img.height);
    contrast();
    press = false;
    
    
  } else if (key == '3') {
    img = loadImage("dogcat.png");
    original_img.copy(img, 0, 0, img.width, img.height, 0, 0, original_img.width, original_img.height);
    image(img, 0, 0);  
    img.loadPixels();
    PImage edgeImg = createImage(img.width, img.height, RGB);
    
    for (int y = 1; y < img.height-1; y++) {   
      for (int x = 1; x < img.width-1; x++) {  
        float sumr = 0; 
        float sumg = 0;
        float sumb = 0;
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            
            int pos = (y + ky)*img.width + (x + kx);
            
            float val_r = red(img.pixels[pos]);
            float val_g = green(img.pixels[pos]);
            float val_b = blue(img.pixels[pos]);
            
            sumr += kernel[ky+1][kx+1] * val_r;
            sumg += kernel[ky+1][kx+1] * val_g;
            sumb += kernel[ky+1][kx+1] * val_b;
          }
        }

        
        sumr = constrain(sumr, 0, 255);
        sumg = constrain(sumg, 0, 255);
        sumb = constrain(sumb, 0, 255);
        edgeImg.pixels[y*img.width + x] = color(sumr, sumg, sumb);
      }
    }

    
    edgeImg.updatePixels();

    image(edgeImg, 0, 0); 
    press = true;
  }
  
  
  else if (key == '4'){
    img = loadImage("dogcat.png");
    original_img.copy(img, 0, 0, img.width, img.height, 0, 0, original_img.width, original_img.height);
    image(img, 0, 0); 
    img.loadPixels();

    
    PImage edgeImg = createImage(img.width, img.height, RGB);
   
    
    for (int y = 1; y < img.height-1; y++) {   
      for (int x = 1; x < img.width-1; x++) {  
        float sumr_hor = 0; 
        float sumg_hor = 0;
        float sumb_hor = 0;
        float sumr_ver = 0; 
        float sumg_ver = 0;
        float sumb_ver = 0;
        float root_r = 0;
        float root_g = 0;
        float root_b = 0;
       
        for (int ky = -1; ky <= 1; ky++) {
          for (int kx = -1; kx <= 1; kx++) {
            
            int pos = (y + ky)*img.width + (x + kx);
             
            float val_r = red(img.pixels[pos]);
            float val_g = green(img.pixels[pos]);
            float val_b = blue(img.pixels[pos]);
            
            sumr_hor += hor[ky+1][kx+1] * val_r;
            sumg_hor += hor[ky+1][kx+1] * val_g;
            sumb_hor += hor[ky+1][kx+1] * val_b;
            
            sumr_ver += ver[ky+1][kx+1] * val_r;
            sumg_ver += ver[ky+1][kx+1] * val_g;
            sumb_ver += ver[ky+1][kx+1] * val_b;
            
            //math for r value
            float squared_r_hor = sumr_hor * sumr_hor;
            float squared_r_ver = sumr_ver * sumr_ver;
            float added_r = squared_r_hor + squared_r_ver;
            root_r = sqrt(added_r);
            
            //math for g value
            float squared_g_hor = sumg_hor * sumg_hor;
            float squared_g_ver = sumg_ver * sumg_ver;
            float added_g = squared_g_hor + squared_g_ver;
            root_g = sqrt(added_g);
            
            //math for b value
            float squared_b_hor = sumb_hor * sumb_hor;
            float squared_b_ver = sumb_ver * sumb_ver;
            float added_b = squared_b_hor + squared_b_ver;
            root_b = sqrt(added_b);
     
            
          }
        }

        
        root_r = constrain(root_r, 0, 255);
        root_g = constrain(root_g, 0, 255);
        root_b = constrain(root_b, 0, 255);
        edgeImg.pixels[y*img.width + x] = color(root_r, root_g, root_b);
      }
    }

    
    edgeImg.updatePixels();

    image(edgeImg, 0, 0); 
    press = true;
    
    
  }
}