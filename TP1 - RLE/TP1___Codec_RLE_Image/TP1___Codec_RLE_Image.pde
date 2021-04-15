// MOUFFOK Tayeb Abderraouf   #   171731070920    #    MIV Groupe 2    #    rafainiestaretro@gmail.com

String encode(String str){
  /*
        Fonction qui retourne la chaine str compressée
  */
  
  int i = 0;
  int len = str.length();
  String encodedString = "";
  
  
  while(i<len-2){
    
    // Tester s'il y a 3 fois de suite une même couleur 
    if((i+5<len)&&(str.charAt(i) + str.charAt(i+1) == str.charAt(i+2) + str.charAt(i+3)) && (str.charAt(i+2) + str.charAt(i+3) == str.charAt(i+4) + str.charAt(i+5))){
      
      // Couleur redondante 3 fois ou plus
      int j = i;
      while((j+3<len)&&(str.charAt(j) + str.charAt(j+1) == str.charAt(j+2) + str.charAt(j+3))){
        j+=2;
      }
      int charLen = (j - i)/2 + 1;
      while(charLen >= 32768){
          encodedString = encodedString + hex(32768 + charLen) + str.charAt(i) + str.charAt(i+1);
          charLen = charLen - 32768;
      }
      encodedString = encodedString + hex(32768 + charLen, 4) + str.charAt(i) + str.charAt(i+1);
      i = j + 2;
      

     if(i == len-2){
       encodedString = encodedString + hex(1, 4) + str.charAt(i) + str.charAt(i+1);
       i = len;
     }
    }
    
    else{
      
      // Couleurs non redondantes
      int j = i;
      String s = "";
      while((j<len-4)&&((str.charAt(j) + str.charAt(j+1) != str.charAt(j+2) + str.charAt(j+3))||str.charAt(j+2) + str.charAt(j+3) != str.charAt(j+4) + str.charAt(j+5))){
        s = s+str.charAt(j)+str.charAt(j+1);
        j+=2;
      }
      if(j == len-4){
        s = s+str.charAt(j)+str.charAt(j+1)+str.charAt(j+2)+str.charAt(j+3);
        j+=2;
      }
      
      int charLen = s.length() / 2;
      while(charLen >= 32768){
          encodedString = encodedString + hex(charLen,4) + s;
          charLen = charLen - 32768;
      }
      
      if(charLen > 0){
        encodedString = encodedString + hex(charLen,4) + s;
      }
      i = j;
    }
  }
  
return encodedString;
}


String decode(String str){
  /*
        Fonction qui retourne la chaine str décompressée
  */

  String decodedString = "";
  int i = 0;
  int len = str.length();
  while(i < len){
    // get first 2 Bytes in binary
    String code = binary(unhex(str.substring(i, i+4)),16);
    
    if(code.charAt(0) == '1'){
      int timesRepeat = int(unbinary(code.substring(1,16)));
      for(int a=0; a<timesRepeat; a++){
        decodedString = decodedString + str.charAt(i+4) + str.charAt(i+5);
      }
      i = i+6;
    }
    else{
      int nbChars = int(unbinary(code.substring(1,16))) * 2;
      decodedString = decodedString + str.substring(i+4, i+4+nbChars);
      i = i+4+nbChars;
    }
  }
  
  return decodedString;
}


float compressionRatio(String decodedString, String encodedString){
  /*
        Fonction qui calcule et retourne le taux de compression
  */
  return 100 - encodedString.length()*100 / decodedString.length();
}


void compresser(String str){
  /*
        Fonction qui compresse une chaine et affiche le résultat, ainsi que le taux de compression
  */
  String encodedString = encode(str);
  print("Image à compresser : ", str);
  print("\n");
  print("Image compressée : ", encodedString);
  print("\n");
  print("Taux de compression : ", compressionRatio(str, encodedString)+"%");
}


void decompresser(String str){
  /*
        Fonction qui décompresse une chaine et affiche le résultat, ainsi que le taux de compression
  */
  String decodedString = decode(str);
  print("Image à compresser : ", str);
  print("\n");
  print("Image compressée : ", decodedString);
  print("\n");
  print("Taux de compression : ", compressionRatio(decodedString, str)+"%");
}

void afficher(String str){
  /*
        Fonction qui affiche l'image 6*6 de la chaine donnée en paramètre
  */
  int x = 0;
  int y = 0;
  for(int i=0; i<str.length(); i=i+2){
    //noStroke();
    String c = "";
    c += str.charAt(i);
    c += str.charAt(i+1);
    switch(c){
      case "FF":
        fill(255);
        break;
      case "00":
        fill(0);
        break;
      default:
        print("color isnt black or white", c,"\n");      
    }
    println(x,y);
    square(x,y,40);
    x = x + 40;
    if((i>0)&&(((i/2)+1)%6 == 0)){
      y = y + 40;
      x=0;
    }
  }
}

void setup(){
  size(240,240);
  String imageString = "00FF00FF00FFFF00FF00FF0000FF00FF00FFFF00FF00FF0000FF00FF00FFFF00FF00FF00";
  //String imageString = "000000FFFFFFFFFFFF000000000000FFFFFF000000FFFFFFFFFFFF000000000000FFFFFF00";
  //String imageString = "000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000";
  compresser(imageString);
  print("\n\nFin");
  afficher(imageString);
  
}

void draw(){
}
