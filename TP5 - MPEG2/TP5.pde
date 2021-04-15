Rectangle redRect = new Rectangle();
Rectangle greenRect = new Rectangle();
Rectangle closestRect = new Rectangle();

int DELTA = 40;
int BLOC_SIZE = 16;
boolean pressing = false;
boolean rectSelected = false;
boolean done = false;

void setup(){
  size(1920, 1080);
  PImage frame1 = loadImage("frame1.png");
  PImage frame2 = loadImage("frame2.png");
  redRect.setFrames(frame1, frame2);
  greenRect.setFrames(frame1, frame2);
  closestRect.setFrames(frame1, frame2);
  image(frame1,0,0);
  
}


void draw(){
}


void drawGreenRect(){    
  int x1, y1, x2, y2;
    if(redRect.x2 > redRect.x1){
        x1 = redRect.x1 - DELTA;
        x2 = redRect.x2 + DELTA;
    }
    else{
        x1 = redRect.x1 + DELTA;
        x2 = redRect.x2 - DELTA;
    }
    
    if(redRect.y2 > redRect.y1){
        y1 = redRect.y1 - DELTA;
        y2 = redRect.y2 + DELTA;
    }
    else{
        y1 = redRect.y1 + DELTA;
        y2 = redRect.y2 - DELTA;
    }
    greenRect.updateValues(x1, y1, x2, y2);
    stroke(0,255,0);
    greenRect.drawRect();
}


void keyReleased(){
  if(key==' '){
        diff2images(redRect.frame1, redRect.frame2);
    }
}


void setRedRect(int x1, int y1, int x2, int y2){
  redRect.updateValues(x1,y1,x2,y2);
  redRect.getRectImage(1);
}

void setGreenRect(){
    int x1, y1, x2, y2;
    if(redRect.x2 > redRect.x1){
        x1 = redRect.x1 - DELTA;
        x2 = redRect.x2 + DELTA;
    }
    else{
        x1 = redRect.x1 + DELTA;
        x2 = redRect.x2 - DELTA;
    }
    
    if(redRect.y2 > redRect.y1){
        y1 = redRect.y1 - DELTA;
        y2 = redRect.y2 + DELTA;
    }
    else{
        y1 = redRect.y1 + DELTA;
        y2 = redRect.y2 - DELTA;
    }
      
    greenRect.updateValues(x1, y1, x2, y2);
    greenRect.getRectImage(2);

}



Rectangle searchMostSimilar(){
    
    Rectangle grayRect = new Rectangle();
    grayRect.setFrames(redRect.frame1,redRect.frame2);
    
    int redImageWidth = redRect.savedImage.width;
    int redImageHeight = redRect.savedImage.height;
    
    int greenImageWidth = greenRect.savedImage.width;
    int greenImageHeight = greenRect.savedImage.height;
    
    float minMSE = (float) Double.POSITIVE_INFINITY;
    float a = millis();
    
    for(int i=0; i<greenImageHeight-redImageHeight; i++){
        for(int j=0; j<greenImageWidth-redImageWidth; j++){
             
             //print(i,j+"\n");
             grayRect.updateValues(greenRect.x1+i, greenRect.y1+j, greenRect.x1+i+redImageWidth, greenRect.y1+j+redImageHeight);
             float rectMSE = compare2Images(redRect.savedImage, grayRect.getRectImage(2));
             if(rectMSE < minMSE){
                 minMSE = rectMSE;
                 closestRect.updateValues(greenRect.x1+i, greenRect.y1+j, greenRect.x1+i+redImageWidth, greenRect.y1+j+redImageHeight);
                 //print(minMSE+"\n");
                 closestRect.getRectImage(2);
             }
             //break;             
        }
        //break;
    }
    float b = millis()-a;
    //print("Time d'exécution : "+b+"\n");//2853.0    330.0
    
    int dep_x=closestRect.x1-redRect.x1;
    int dep_y=closestRect.y1-redRect.y1;
    //print("Déplacement : ("+dep_x+", "+dep_y+")\n"); 
    //print("Erreur : "+minMSE);
    //print("\n\n");
    stroke(#0000FF);
    closestRect.getRectImage(2);
    return closestRect;

}


float[] colorToYCbCr(color c){
  /* Fonction qui convertit une color RGB en YCbCr 
  Paramètres : color c 
  Retourne : Float Array de type : [Y, Cb, Cr]
  */
  
    /*float y = 0.299*red(c) + 0.587*green(c) + 0.114*blue(c);
    float cb = 128 - 0.168736 * red(c) - 0.331264 * green(c) + 0.5 * blue(c);
    float cr = 128 + 0.5 * red(c) - 0.418688 * green(c) - 0.081312 * blue(c);*/

    float y = 16 + 0.257*red(c) + 0.504*green(c) + 0.098*blue(c);
    float cb = 128 - 0.148*red(c) - 0.291*green(c) + 0.439*blue(c);
    float cr = 128 + 0.439*red(c) - 0.368*green(c) - 0.071*blue(c);
  
    float[] YCbCr = new float[3];
    YCbCr[0] = y;
    YCbCr[1] = cb;
    YCbCr[2] = cr;
    
    return YCbCr;
}

color YCbCrToColor(float[] YCbCr){
  float y = YCbCr[0];
  float Cb = YCbCr[1];
  float Cr = YCbCr[2];
  
  /*float r = y + 1.402*(Cr-128);
  float g = (y - 0.344136)*(Cb-128) - 0.714136*(Cr-128);
  float b = y + 1.772*(Cb-128);*/
  
  float r = 1.164*(y-16) + 1.596*(Cr-128);
  float g = 1.164*(y-16) - 0.392*(Cb-128) - 0.813*(Cr-128);
  float b = 1.164*(y-16) + 2.017*(Cb-128);
  
  r = max(0, min(r, 255));
  g = max(0, min(g, 255));
  b = max(0, min(b, 255));
  
  return color(r, g, b);
}


float[][] sub2images(PImage img1, PImage img2){
  
  float[][] result = new float[img1.pixels.length][3];
  
  colorMode(RGB);
  
  img1.loadPixels();
  img2.loadPixels();
  
  for(int i=0; i<img1.pixels.length; i++){
            color c1 = img1.pixels[i];
            color c2 = img2.pixels[i];
            
            float[] c1_ycbcr = new float[3];
            float[] c2_ycbcr = new float[3];
            
            c1_ycbcr = colorToYCbCr(c1);
            c2_ycbcr = colorToYCbCr(c2);
            
            float[] c_ycbcr = new float[3];
            c_ycbcr[0] = c2_ycbcr[0] - c1_ycbcr[0];
            c_ycbcr[1] = c2_ycbcr[1] - c1_ycbcr[1];
            c_ycbcr[2] = c2_ycbcr[2] - c1_ycbcr[2];
            
            //print(y1, y2);
            
            
            result[i] = c_ycbcr;
        
        
    }
    
  return result;

}


void drawImage(float[][] mat, int x, int y){
  PImage img = createImage(redRect.savedImage.width, redRect.savedImage.height, RGB);
  img.loadPixels();
  
  for(int i=0; i<img.pixels.length; i++){    
    img.pixels[i] = YCbCrToColor(mat[i]);
  }
  
  image(img,x,y);

}


float calculate_MSE(float[][] mat){
  float error = 0;
    for(int i = 0; i<mat.length; i++){
        error += mat[i][0]*mat[i][0];
    }
    //print("mat len : "+mat.length+"\n");
    float MSE = error/mat.length;
    
    return MSE;
}


float compare2Images(PImage img1, PImage img2){
  
    float[][] result = new float[img1.height*img1.width][3];
    result = sub2images(img1, img2);
    float MSE = calculate_MSE(result);
    //drawImage(result,0,0);
    //print(MSE);
    return MSE;
}






void diff2images(PImage img1, PImage img2){
  Rectangle rect = new Rectangle();
  int cpt = 0;
  double start = millis();
  
  //print(img1.width, img1.height);
  int nb_blocs = ((img1.width/BLOC_SIZE)+1) * ((img1.height/BLOC_SIZE)+1);
  
  for(int i=0; i<img1.width; i+=BLOC_SIZE){
    for(int j=0; j<img1.height; j+=BLOC_SIZE){
      //print(i,j+"\n");
      setRedRect(i,j,i+BLOC_SIZE, j+BLOC_SIZE);
      setGreenRect();
      rect = searchMostSimilar();
      rect.savedImage.loadPixels();
      float[][] mat_residus = new float[rect.savedImage.pixels.length][3];
      mat_residus = sub2images(rect.savedImage, redRect.savedImage);
      drawImage(mat_residus, i, j);
      cpt += 1;
      if(cpt%4==0){
        print(cpt+"/"+nb_blocs+"\t\t\t"+float(cpt*100/nb_blocs)+"%\n");
      }
      
      
    }
  }
  print(nb_blocs+"/"+nb_blocs+"\t\t\t100%\n");
  print("Traitement terminé, résultat sauvegardé dans \"residus.png\"");
  print("Temps du traitement : " + (millis() - start)+"ms\n");
  save("residus.png");
}
