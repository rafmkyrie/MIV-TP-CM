// MOUFFOK Tayeb Abderraouf   #   171731070920    #    MIV Groupe 2    #    rafainiestaretro@gmail.com

String encode(String str){
  int i = 0;
  int len = str.length();
  String encodedString = "";
  while(i<len){
    
    // Condition qui vérifie si 3 ou plus mêmes caractères se suivent
    if((i+2<len)&&(str.charAt(i) == str.charAt(i+1)) && (str.charAt(i+1)== str.charAt(i+2))){

      // 3 ou plus mêmes caractères se suivent
      int j = i;
      while((j<len-1)&&(str.charAt(j) == str.charAt(j+1))){
        j++;
      }
      int charLen = j + 1 - i;
      while(charLen >= 32768){
          encodedString = encodedString + hex(32768 + charLen) + str.charAt(i);
          charLen = charLen - 32768;
      }
      encodedString = encodedString + hex(32768 + charLen, 4) + str.charAt(i);
      i = j + 1;
    }
    
    else{
      // il n'y a pas 3 ou plus mêmes caractères qui se suivent
      int j = i;
      String s = "";
      
      while((j<len-1)&&((str.charAt(j) != str.charAt(j+1))||(str.charAt(j+1) != str.charAt(j+2)))){
        s = s+str.charAt(j);
        j++;
      }
      if(j == len-1){
        s = s + str.charAt(j);
        j++;
      }
      
      int charLen = j - i;
      while(charLen >= 32768){
          encodedString = encodedString + hex(charLen,4) + s;
          charLen = charLen - 32768;
      }
      encodedString = encodedString + hex(charLen,4) + s;
      i = j;
    }
  }
return encodedString;
}


String decode(String str){
  String decodedString = "";
  int i = 0;
  int len = str.length();
  while(i < len){
    // get first 2 Bytes in binary
    String code = binary(unhex(str.substring(i, i+4)),16);
    
    if(code.charAt(0) == '1'){
      int timesRepeat = int(unbinary(code.substring(1,16)));
      for(int a=0; a<timesRepeat; a++){
        decodedString = decodedString + str.charAt(i+4);
      }
      i = i+5;
    }
    else{
      int nbChars = int(unbinary(code.substring(1,16)));
      decodedString = decodedString + str.substring(i+4, i+4+nbChars);
      i = i+nbChars+4;
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



String string_to_encode = "aabbaaaaaccccabcd";
String encoded_string, decoded_string;
float taux_de_compression;

void setup(){
  size(600,200);
  
  encoded_string = encode(string_to_encode);
  print("La chaine encodée : " + encoded_string);
  print("\n");
  
  decoded_string = decode(encoded_string);
  print("La chaine décodée : " + decode(encoded_string));
  print("\n");

  taux_de_compression = compressionRatio(decoded_string, encoded_string);
  print("Taux de compression : " + taux_de_compression+"%");
}

void draw(){
  background(0);
  fill(255);
  textSize(20);
  
  text("La chaine encodée : " + encoded_string, 20, 50);
  text("La chaine décodée : " + decode(encoded_string), 20, 100);
  text("Taux de compression : " + taux_de_compression +"%", 20, 150);
}
