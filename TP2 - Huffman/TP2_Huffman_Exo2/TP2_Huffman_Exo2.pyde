# MOUFFOK Tayeb Abderraouf |  MIV  |  Groupe 2  |  rafainiestaretro@gmail.com  

'''
1) calculer le nombre d'occ pour chaque char dans le document;
2) Ordonner la liste de nombres d'occ (croissant/dec.);
3) Extraire les 2 < valeurs -> la somme;
4) Insérer la somme des deux deux valeurs:
      creer le noeud s (FG, FD)
5) Reordonner la liste;
6) La taille de la liste >= 2?
     oui: aller vers (3)
     sinon: codage (7)
7) Codage:
   pour chque noeud fils gauche la valeur 0/1;
   pour chaque noeud fils droit la valeur  1/0;

8) Coder chaque char du document (phrase).

'''

w = 1900
h = 800


class NodeTree(object):
    ''' Classe Noeud '''

    def __init__(self, left=None, right=None):
        self.left = left
        self.right = right

    def children(self):
        return (self.left, self.right)

    def __str__(self):
        return '%s_%s' % (self.left, self.right)

def sort_list(liste):
    ''' Fonction qui trie la liste des noeuds '''
    liste = sorted(liste, key=lambda tup: tup[1], reverse=True)
    return liste


def compter_nb_chars(string):
    ''' Fonction qui retourne une liste de ('caractère', nb d'occurences) '''

    list_nb_chars = []
    for c in string:
        if c in [i[0] for i in list_nb_chars]:
            for i in list_nb_chars:
                if i[0] == c:
                    i[1] += 1
                    break
        else:
            list_nb_chars.append([c, 1])
            
    list_nb_chars = [tuple(i) for i in list_nb_chars]
            
    return list_nb_chars


def build_tree(liste):
    ''' Fonction qui construit l'arbre et retourne la racine '''
    list_chars = liste[:]
    while len(list_chars) >= 2:
        last_element1 = list_chars.pop()
        last_element2 = list_chars.pop()
        node = NodeTree(last_element2, last_element1)
        list_chars.append(tuple([node, last_element1[1] + last_element2[1]]))
        list_chars = sort_list(list_chars)
        #print(list_chars)

    return list_chars

def build_chars_table(node, left=True, code=''):
    ''' Fonction qui construit la Table des codes des caractères '''
    if type(node) is str:
        return {node: code}
    (left, right) = node.children()
    table = dict()
    table.update(build_chars_table(left[0], True, code + '0'))
    table.update(build_chars_table(right[0], False, code + '1'))
    return table

def draw_line_right(a1, b1, a2, b2, r):
    ''' Fonction qui dessine l'arc entre le noeud parent et le fils de droite '''
    ANGLE = PI/2
    x1 = a1 + (r/2) * cos(ANGLE)
    y1 = b1 + (r/2) * sin(ANGLE) 
    x2 = a2 - (r/2) * cos(ANGLE) 
    y2 = b2 - (r/2) * sin(ANGLE)
    line(x1, y1, x2, y2)
    
def draw_line_left(a1, b1, a2, b2, r):
    ''' Fonction qui dessine l'arc entre le noeud parent et le fils de gauche '''
    ANGLE = PI/2
    x1 = a1 - (r/2) * cos(ANGLE)
    y1 = b1 + (r/2) * sin(ANGLE) 
    x2 = a2 + (r/2) * cos(ANGLE) 
    y2 = b2 - (r/2) * sin(ANGLE)
    line(x1, y1, x2, y2)
    


def draw_node(node, x=w/2, y=50, x_space=w/2, r=65):
    ''' Fonction qui dessine l'arbre '''
    x_space = x_space/2
    y_space = 120
    #print(x, y, t)
    fill(255)
    circle(x, y, r)
    textSize(16)
    fill(0)
    if isinstance(node[0], NodeTree):
        text(str(node[1]), x-(textWidth(str(node[1]))/2), y+5)
        draw_node(node[0].children()[0], x-x_space, y+y_space, x_space)
        draw_line_left(x, y, x-x_space, y+y_space, r)
        draw_node(node[0].children()[1], x+x_space, y+y_space, x_space)
        draw_line_right(x, y, x+x_space, y+y_space, r)
    else:
        text("'" + node[0] + "' : " + str(node[1]), x-(textWidth("'" + node[0] + "' : " + str(node[1]))/2), y+5)

    return


def setup():
    size(w, h)
    
    # Ouverture et lecture du fichier contenant la matrice
    file_path = 'matrice.txt'
    f = open(file_path, 'r')
    matrice = f.read()
    f.close()
    
    # Transformation de la matrice de chaines de caractères à liste de caractères
    matrice = matrice.replace("\n","\t").split("\t")
    main(matrice)
    
    
    
def main(string):
    #string = "bonjouuuuuuuur"
    
    list_chars = compter_nb_chars(string)     # Compter le nb d'occurences de chaque caractère
    list_chars = sort_list(list_chars)        # Trier la liste selon le nombre d'occurences 
    tree = build_tree(list_chars)             # Construire l'arbre
    table = build_chars_table(tree[0][0])     # Construire la table des codes des caractères
    draw_node(tree[0])                        # Dessiner l'arbre
    
    # Affichage de la table des codes des caractères
    print(' Char | Huffman code ')
    print('----------------------')
    for character in [c[0] for c in list_chars]:
        print(' %-4r |%12s' % (character, table[character]))
    
    # Affichages de la chaine de ses codes
    #code_string = ''.join(format(ord(i), 'b') for i in string)   # Récupérer le code binaire de la chaine
    code_string_compressed = ''
    for c in string:
        code_string_compressed += table[c]
    
    print("\n\n\n")
    print("Matrice : " + ", ".join(string))
    #print("Code de la chaine non compressee : " + code_string)
    print("Code de la chaine compressee : " + code_string_compressed) 
    

def draw():
    pass
