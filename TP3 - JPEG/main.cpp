#include <iostream>



#include<stdio.h>
#include<math.h>
#include<windows.h>
#define maxI 7
#define maxJ 7
#define n 64

using namespace std;

typedef struct
		  {
		  int left;
		  int right;
		  int parent;
		  }Noeud_A;

typedef Noeud_A  tree[2*n-1];


typedef struct
		  {
	int lg;
	char code[20];
	float car;
	int poid;
	}Noeud_Al;

typedef Noeud_Al Alphabet[n];
typedef struct
			{
			int poid;
			int root;
			}Noeud_F;

typedef Noeud_F foret[n];

typedef int Image[8][8];
typedef float F[8][8];
typedef int q[8][8];
typedef float mat[8][8];
FILE *e,*s;
float C(int x)
 {
	 float A;
	if (x==0)
	  A = 1.0/sqrt(2);
	else if (x > 0)
	  A = 1.0;
 return A;
 }
float dcti(mat DCT,int u,int v)
  {
  int i,j;
float C1,D;
D=0;

for(i=0;i<8;i++)
{
	for(j=0;j<8;j++)
		{


	  fscanf(e,"%f",&C1);

		D+=C(j)* C(i) * C1 * DCT[i][j];

		}

  }

  return D;
}
float dct(Image Im,int u,int v)
  {
  int i,j;
float C,D;
D=0;

for(i=0;i<8;i++)
{
	for(j=0;j<8;j++)
		{



	  fscanf(e,"%f",&C);

		D+=C*Im[i][j];

		}

  }

  return D;
}

 /////////////// affichage des code //////////////
 void code(tree arbre, Alphabet alph, int nb,mat Mat)
{  FILE *s;

	int i,j, k,u,v;
	printf("\n Les codes des caracteres : \n");
	for(i=0;i<nb;i++)
	{
		printf("\n Le code de (val:'%f',freq: %d) est : ",alph[i].car,alph[i].poid);

		k=i;
		j=0;
		while(arbre[k].parent !=-1)
		{
			if(k==arbre[arbre[k].parent].left)
				alph[i].code[j]=0;
			else /* si le sous arbre est gauche : arbre[arbre[k].parent].right */
				alph[i].code[j]=1;
			k=arbre[k].parent;
			j++;
		}
		alph[i].lg = j;           //enregistrer la longueur du code .
		for(k=j-1; k>=0;k--)
			printf("%d ",alph[i].code[k]);
	}
// stockage des codes dans un fichier
	  s=fopen("codage.txt","w+");
	 for(u=0;u<8;u++)
	 {
		for(v=0;v<8;v++)
		 {
				  i=0;
				  while(i<nb)
				  {
					if(Mat[u][v]== alph[i].car)
					 {
					 for(k=alph[i].lg-1; k>=0;k--)
					 fprintf(e,"%d ",alph[i].code[k]);
					 i=nb;
					  }
					 i++;
					  }
					fprintf(e,"\n");
		  }

	 }
	  fclose(s);
}

 //////////////////////////////////////////////////////////////////////////
 /* smallest retourne les indices des arbres de frequence min de la foret */
void smallest(int *least, int *second, int lasttree, foret forest)
{
	int i;
	if(forest[0].poid < forest[1].poid)
	{
		*least=0;
		*second=1;
	}
	else
	{
		*least=1;
		*second=0;
	}
	for(i=2;i<lasttree;i++)
	if(forest[i].poid < forest[*least].poid)
	{
		*second=*least;
		*least=i;
	}
	else if(forest[i].poid < forest[*second].poid)
		*second=i;
}
 /// huffman
void Huffman(foret forest, int lastnode, int lasttree, tree arbre)  /*  créer l'arbre  */
{
	int i, j;
	/* test s'il ya des arbres dans foret pour créer un nouveau noeud */
	while(lasttree > 1)
	{
		smallest(&i, &j, lasttree, forest);
		/* chercher les indices des arbres de frequence min de la foret

				/* créer un nouveau noeud dont le sous arbre gauche sera
				i et le sous arbre droit  j et leur parent  lastnode */
		lastnode++;
		arbre[lastnode].left=forest[i].root;
		arbre[lastnode].right=forest[j].root;
		arbre[forest[i].root].parent=lastnode;
		arbre[forest[j].root].parent=lastnode;

		forest[i].poid = forest[i].poid + forest[j].poid;   //la somme des deux poid du nouveau noeud
		forest[i].root = lastnode;                         //le numero du nouveau .
		/* j sera écrasé par le dernier arbre de la foret */
		forest[j] = forest[lasttree-1];
		/*   on supprime le dernier arbre de la foret   */
		lasttree--;
	}
}

 /// zigzag
void zigzagcallhuff(mat Mat,Alphabet alpha)
{
tree arbre;
//Alphabet alpha;
foret forest;
int croiss=0,i,j;
int lasttree,lastnode,nb=0,a;
// initialisation
for(i=0;i<64;i++)
			  {
			  alpha[i].car  = -1000;
			  forest[i].root =-1000;
			  alpha[i].poid = 0;
			  forest[i].poid = 0;
			  }

i=0;
j=0;
a=0;
/// zigzag et fréquence
while (i <= maxI && j <= maxJ)
{
	 //printf("%f \t",Mat[i][j]);
		 for(a=0;a<n;a++)
		  {
			if((alpha[a].car == Mat[i][j]))
			  {
				 alpha[a].poid = alpha[a].poid + 1;
				 forest[a].poid=alpha[a].poid;
				 forest[a].root=a;
				 printf("%f \t",alpha[a].car);
				 a=n;
			  }
			  else if (alpha[a].car == -1000)
			  {
				alpha[a].car = Mat[i][j];
				alpha[a].poid = alpha[a].poid + 1;
				forest[a].poid=alpha[a].poid;
				forest[a].root=a;
				nb++;
				printf("%f \t",alpha[a].car);
				a=n;
			  }
			 }
	 if (i == 0 || i == maxI)
	{
		  if (j == maxJ)
		{
				j = j - 1;
				i = i + 1;
		}
		  j = j + 1;
		  //printf("%f \t",Mat[i][j]);
		  for(a=0;a<n;a++)
		  {
			if((alpha[a].car == Mat[i][j]))
			  {
				 alpha[a].poid = alpha[a].poid + 1;
				 forest[a].poid=alpha[a].poid;
				 forest[a].root=a;
				 printf("%f \t",alpha[a].car);
				 a=n;

			  }
			  else if (alpha[a].car == -1000)
			  {
				alpha[a].car = Mat[i][j];
				alpha[a].poid = alpha[a].poid + 1;
				forest[a].poid=alpha[a].poid;
				forest[a].root=a;
				nb++;
				printf("%f \t",alpha[a].car);
				a=n;
			  }
			 }

	}
	 else
	{
		  if (j == 0 || j == maxJ)
		{
				if (i == maxI)
			{
					 i = i - 1;
					 j = j + 1;
			}
				i = i + 1;

			for(a=0;a<n;a++)
		  {
			if((alpha[a].car == Mat[i][j]))
			  {
				 alpha[a].poid = alpha[a].poid + 1;
				 forest[a].poid=alpha[a].poid;
				 forest[a].root=a;
				 printf("%f \t",alpha[a].car);
				 a=n;
			  }
			  else if (alpha[a].car == -1000)
			  {
				alpha[a].car = Mat[i][j];
				alpha[a].poid = alpha[a].poid + 1;
				forest[a].poid=alpha[a].poid;
				forest[a].root=a;
				nb++;
				printf("%f \t",alpha[a].car);
				a=n;
			  }
			 }
  //	printf("%f \t",Mat[i][j]);
		}
	}

		if (i == 0 || j == maxJ) { croiss = 0;}
		if (j == 0 || i == maxI)  { croiss = 1;}

	 if (croiss==1)
	{
		  i = i - 1;
		  j = j + 1;
	}
	else
	{
		  i = i + 1;
		  j = j - 1;
	}

}


lasttree = nb;
lastnode = nb-1;
//initialisation de l'arbre
for(i=0;i<nb*2-1;i++)
			  {
			arbre[i].left=-1;
			arbre[i].parent=-1;
			arbre[i].right=-1;
			  }
	 /// appel huffman
 Huffman(forest, lastnode, lasttree, arbre);
	// codage
 code(arbre, alpha, nb,Mat);



}


 int main()
{

int i,j,u,v,choix,var,val,Fq;
float X,Y,N;
Image Im;
F DCT,PIXEL;
mat Mat;       //quantifié
q Q; //quantité
Alphabet alph;
char nomfichier[30];
for(i=0;i<8;i++)
  {
  for(j=0;j<8;j++)
	 {
	  Im[i][j] = 0;
	  DCT[i][j] = 0;
	  Mat[i][j] = 0;

	 }
	}
N=8.0;
i=0;
j=0;
printf("\t\t*******  MENU  *******\n");
printf("\n");
printf(" 1-Lecture de la matrice IM .\n");
printf("\n");
printf(" 2- Calcul de la DCT.\n");
printf("\n");
printf(" 3- Quantification.\n");
printf("\n");
printf("4- Compression Huffman. En sortie le fichier (codage.txt)\n");
printf("\n");
printf("6- Transformation inverse de la DCT\n");
printf("\n");
printf(" 7- Quitter le programme.\n");
printf("\n");
var = 1;

do
	{
		printf(" Tapez votre choix SVP:");
		scanf("%d",&choix);
		 switch(choix)
		 {
	case 1:  printf("introduire le nom de votre fichier correspondant a l'image: \n");
				scanf("%s",nomfichier);
				 s=fopen(nomfichier,"r");
				while(!s)
					{
			 printf("ERREUR  le fichier %s n existe pas!!\n",nomfichier);
			 printf("\n Veuillez saisir le nom du fichier a  analyser\n: ");
			 scanf("%s",nomfichier);
			 s=fopen(nomfichier,"r");

				  }
				for(i=0;i<8;i++)
				{
				for(j=0;j<8;j++)
				  {


			  fscanf(s,"%d",&val);
			  Im[i][j]=val;

				  }
				}

			fclose(s);
			 break;

	case 2:  e=fopen("cos.txt","r");
			  printf("\n Matrice DCT calculee: \n\n");
				for(u=0;u<8;u++)
			  {
			  for(v=0;v<8;v++)
				  {
						 X = dct(Im,u,v);

						DCT[u][v] = (int)((2.0/N) * C(u) * C(v) * X);
						printf("%.2f \t",DCT[u][v]);
					}
					  printf("\n");
				}
				fclose(e);

			 break;
	case 3:      printf("\n Facteur de qualite : ");
					 scanf("%d",&Fq);
							 printf("\n Matrice de qualite : \n\n");
							 for(i=0;i<8;i++)
							 {
							 for(j=0;j<8;j++)
								{
									Q[i][j]=1+(1+i+j)*Fq;
								  printf("%d   ",Q[i][j]);
								 }
								printf("\n");
								}
							  printf("\n");
							  printf("\n Matrice DCT quantifie : \n\n");
						  for(i=0;i<8;i++)
							 {
							 for(j=0;j<8;j++)
								{

								  Mat[i][j]= (int)(DCT[i][j] / Q[i][j]);
								  printf("%.2f \t",Mat[i][j]);
								 }
								printf("\n");
								}
					  break;
	case 4:
					 zigzagcallhuff(Mat,alph);
					 break;
	case 5:    printf("decodage");
				  break;
	case 6: printf("\nla processus quantification inverse :\n");
					for(u=0;u<8;u++)
					{
					for(v=0;v<8;v++)
					  {
					  DCT[u][v] = Q[u][v] * Mat[u][v];
					  printf("%.2f \t",DCT[u][v]);
					  }
						  printf("\n");
					  }
				 e=fopen("cos2.txt","r");
			  printf("\nvoici la transformée dct inverse : \n\n");
				for(u=0;u<8;u++)
			  {
			  for(v=0;v<8;v++)
				  {
						Y = dcti(DCT,u,v);
						PIXEL[u][v] = (int)((2.0/N) * Y);
						printf("%.2f \t",PIXEL[u][v]);
				  }
					  printf("\n");
				  }
				fclose(e);
	default:var=0;
			 printf("\t\t*******  FIN DU PROGRAMME  *******\n");
		 }

	}
	while(var==1);
return 0;
}


