Rectangle redRect = new Rectangle();
Rectangle greenRect = new Rectangle();
Rectangle closestRect = new Rectangle();

int DELTA = 80;
boolean pressing = false;
boolean rectSelected = false;
boolean done = false;

void setup(){
  size(1920, 1080);
  PImage frame1 = loadImage("frame1.png");
  PImage frame2 = loadImage("frame2.png");
  redRect.setFrames(frame1, frame2);
  image(frame1,0,0);
}


void draw(){
  if(pressing){
    //fill(255,0,0, 30);
    noFill();
    redRect.x2 = mouseX;
    redRect.y2 = mouseY;
    background(redRect.frame1);
    redRect.drawRect();
  }
}


void mousePressed(){
    done=false;
    rectSelected = false;
    stroke(255,0,0);
    redRect.x1 = mouseX;
    redRect.y1 = mouseY;
    pressing = true;
}


void mouseReleased(){
    pressing = false;
    redRect.x2 = mouseX;
    redRect.y2 = mouseY;
    redRect.updateValues(redRect.x1,redRect.y1,redRect.x2,redRect.y2);
    background(redRect.frame1);
    redRect.drawRect();
    redRect.getRectImage();
    stroke(255,0,0);
    strokeWeight(2);
    noFill();
    redRect.drawRect();
    drawGreenRect();
    rectSelected = true;
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
  if(key=='m')
    background(redRect.frame1);
  if(key=='a'){
        pressing = false;
        redRect.x2 = mouseX;
        redRect.y2 = mouseY;
        redRect.updateValues(412, 378, 472, 557);
        background(redRect.frame1);
        redRect.drawRect();
        redRect.getRectImage();
        stroke(255,0,0);
        strokeWeight(2);
        noFill();
        redRect.drawRect();
        drawGreenRect();
        rectSelected = true;
    }
  if(rectSelected){
    if(key==' '){
        background(redRect.frame2);
        greenRect.drawRect();
        searchMostSimilar();
        done=true;
    }
  }
  if(done){
    if((key=='s')||(key=='S')){
        fill(0,220);
        rect(0,0,width,height);
        textAlign(CENTER,CENTER);
        textSize(30);
        fill(255);
        text("Frame 1", width/3+(redRect.x2-redRect.x1)/2,height/3-40);
        image(redRect.savedImage,width/3,height/3);
        text("Frame 2", 2*width/3+(closestRect.x2-closestRect.x1)/2,height/3-40);
        image(closestRect.savedImage,2*width/3,height/3);
        done=false;
    }  
  }
  if((key=='m')||(key=='M')){
        background(redRect.frame1);
  }
}


void searchMostSimilar(){
 
  
    // Afficher les rectangles
    Rectangle grayRect = new Rectangle();
    
    int redImageWidth = redRect.savedImage.width;
    int redImageHeight = redRect.savedImage.height;
    
    int greenImageWidth = greenRect.getRectImage().width;
    int greenImageHeight = greenRect.getRectImage().height;
    
    float minMSE = (float) Double.POSITIVE_INFINITY;
    float a = millis();
    
    for(int i=0; i<greenImageHeight-redImageHeight; i++){
        for(int j=0; j<greenImageWidth-redImageWidth; j++){
             
             print(i,j+"\n");
             grayRect.updateValues(greenRect.x1+i, greenRect.y1+j, greenRect.x1+i+redImageWidth, greenRect.y1+j+redImageHeight);
             float rectMSE = compare2Images(redRect.savedImage, grayRect.getRectImage());
             if(rectMSE < minMSE){
                 minMSE = rectMSE;
                 closestRect.updateValues(greenRect.x1+i, greenRect.y1+j, greenRect.x1+i+redImageWidth, greenRect.y1+j+redImageHeight);
                 //print(minMSE+"\n");
                 closestRect.getRectImage();
             }
             //break;
             
             
             
        }
        //break;
    }
    float b = millis()-a;
    print("Time d'exécution : "+b+"\n");//2853.0    330.0
    
    int dep_x=closestRect.x1-redRect.x1;
    int dep_y=closestRect.y1-redRect.y1;
    print("Déplacement : ("+dep_x+", "+dep_y+")\n"); 
    print("Erreur : "+minMSE);
    print("\n\n");
    stroke(#0000FF);
    closestRect.drawRect();

}


float[] colorToYCbCr(color c){
  
    float y = 0.299*red(c) + 0.587*green(c) + 0.114*blue(c);
    float cb = 128 - 0.168736 * red(c) - 0.331264 * green(c) + 0.5 * blue(c);
    float cr = 128 + 0.5 * red(c) - 0.418688 * green(c) - 0.081312 * blue(c);
  
    float[] YCbCr = new float[3];
    YCbCr[0] = y;
    YCbCr[1] = cb;
    YCbCr[2] = cr;
    
    return YCbCr;
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
    img1.loadPixels();
    img2.loadPixels();
    
    float mse = 0;
    
    colorMode(RGB);
    
    for(int i=0; i<img1.pixels.length; i++){
            color c1 = img1.pixels[i];
            color c2 = img2.pixels[i];
            
            float y1 = 0.299*red(c1) + 0.587*green(c1) + 0.114*blue(c1);
            float y2 = 0.299*red(c2) + 0.587*green(c2) + 0.114*blue(c2);
            
          
            mse += (y2 - y1)*(y2 - y1);
        
    }
    
    mse = mse/(img1.height*img1.width);
    return mse;
 
}
