#include<stdio.h>
#include<dlfcn.h> //for dynamic libraries
#include<string.h>
int main()
{
    char s2[7];
    int n,m;
    while(scanf("%s %d %d",s2,&n,&m)==3) //till 3 inputs are recieved
    {
        char s1[20]="./lib";
        char s3[5]=".so";
        strcat(s1,s2); // used to make desired file name
        strcat(s1,s3); 
        // s1 ="./lib<op>.so"
        void *library=dlopen(s1,RTLD_LAZY);
        int(*operation)(int,int)=dlsym(library,s2);// getting operation function from library
        printf("%d\n",operation(n,m));
        dlclose(library); // closing for 2 gb limit
    }
    return 0;
}
