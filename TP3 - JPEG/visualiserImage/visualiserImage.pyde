import re
w = 512
h = 512
matrice=[]

def setup():
    size(w,h)
    file_path = "../image3 - Copie.txt"
    f = open(file_path, 'r')
    matrice_str = f.read()
    f.close()
    matrice = matrice_str.strip().split('\n')
    print(matrice)
    for i in range(len(matrice)):
        matrice[i] = re.sub(' +', ' ', matrice[i])
        matrice[i] = matrice[i].strip().split(" ")
        for j in range(len(matrice[i])):
            matrice[i][j] = matrice[i][j].replace(".00", "")
            #if(matrice[i][j] ==)
            matrice[i][j] = max(min(int(matrice[i][j]), 255),0)
    print(matrice)
    noStroke()
    draw_matrice(matrice)
   
    
    
def draw():
    pass
    
def draw_matrice(matrice):
    y = 0
    while y*h/8<h:
        x = 0
        while x*w/8 < w:
            fill(matrice[y][x])
            square(x*w/8, y*h/8, w/8)
            x+=1
        y+=1
        
