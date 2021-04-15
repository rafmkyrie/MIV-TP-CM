class Rectangle{
  int x1, x2, y1, y2;
  PImage frame1, frame2;
  PImage savedImage;
  
  Rectangle(){
      this.x1 = 0;
      this.y1 = 0;
      this.x2 = 0;
      this.y2 = 0;
  }
  
  Rectangle(int x1, int y1, int x2, int y2){
    if(x1<x2){
      this.x1 = x1;
      this.x2 = x2;
    }
    else{
      this.x1 = x2;
      this.x2 = x1;
    }
    if(y1<y2){
      this.y1 = y1;
      this.y2 = y2;
    }
    else{
      this.y1 = y2;
      this.y2 = y1;
    }
    
    
  }
  
  void updateValues(int x1, int y1, int x2, int y2){
    if(x1<x2){
      this.x1 = x1;
      this.x2 = x2;
    }
    else{
      this.x1 = x2;
      this.x2 = x1;
    }
    if(y1<y2){
      this.y1 = y1;
      this.y2 = y2;
    }
    else{
      this.y1 = y2;
      this.y2 = y1;
    }
  }
  
  void setFrames(PImage f1, PImage f2){
      this.frame1 = f1;
      this.frame2 = f2;
  }
  
  PImage getRectImage(){
    this.savedImage = get(this.x1, this.y1, (this.x2-this.x1), (this.y2-this.y1));
    return this.savedImage;
  }
  
  void drawRect(){
      rect(this.x1, this.y1, (this.x2-this.x1), (this.y2-this.y1));
  }
  
}
