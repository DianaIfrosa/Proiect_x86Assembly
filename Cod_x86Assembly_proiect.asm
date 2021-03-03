.data
   matrix: .space 1600
   n: .space 4  
   m: .space 4     
   roles: .space 84
   cerinta: .space 4
   
   rolhost: .long 1
   rolswitch: .long 2
   rolswitchmalitios: .long 3
   rolcontroller: .long 4 
   ok: .long 1   
   
   index: .space 4 
   index2: .long 0
   i: .space 4
   j: .space 4
   x: .space 4
   y: .space 4
    
    		//subp B
   viz: .space 84
   coada: .space 84
   suma: .space 4
   ult: .space 4
   pr: .space 4
   vf: .space 4
   
   start: .space 4
   finish: .space 4
   len: .space 4
    
    
   sir: .space 20
   formatRead1: .asciz "%d"
   formatRead2: .asciz "%d %d"
   formatReadString: .asciz "%s"

   		
   formatPrint1: .asciz "host index %d; "
   
   
   formatPrintYes: .asciz "Yes"
   formatPrintNo: .asciz "No"
   
   newLine: .asciz "\n"
   
   
   mesaj: .asciz "switch malitios index %d: " 
   mesajhost: .asciz "host index %d; "
   mesajswitch: .asciz "switch index %d; "
   mesajswitchmalitios: .asciz "switch malitios index %d; "
   mesajcontroller: .asciz "controller index %d; "
   
   
.text
.global main

   main:
 
 	//citesc n si m
 pushl $n
 push $formatRead1
 call scanf
 pop %ebx
 pop %ebx
 
 pushl $m
 push $formatRead1
 call scanf
 pop %ebx
 pop %ebx
 
 	//initializez indexul cu care parcurg muchiile
 movl $0, index
 
 lea matrix, %edi
 lea roles, %esi
 
 
 jmp citire_muchii
 
 	
    continua_main1:
 	//trebuie sa citesc roles
 	//initializez indexul cu care parcurg roles
 movl $0, index 
 	
 jmp citire_roles
 
     continua_main2:
 	
 	//ma apuc de cerinte. ATENTIE la input cerinta c
 	//citesc cerinta
 push $cerinta
 push $formatRead1	
 call scanf
 pop %ebx
 pop %ebx
 
 	
 mov cerinta, %eax
 cmp $1, %eax
 je subpa
 cmp $2, %eax
 je subpb
 cmp $3, %eax
 je subpc
 
   citire_roles:

movl index, %ecx
cmp %ecx, n
je continua_main2

push $x
push $formatRead1
call scanf
pop %ebx
pop %ebx

	// la pozitia index in vectorul roles trb sa pun x ul citit
	
movl index, %ecx
movl x, %eax
movl %eax, (%esi, %ecx, 4)

addl $1, index
jmp citire_roles

 
   citire_muchii:

movl index, %ecx
cmp %ecx, m
je continua_main1

pushl $y
pushl $x
push $formatRead2
call scanf
popl %ebx
popl %ebx
popl %ebx


	//a[x][y]=1, calculez pozitia liniarizata
movl x,%eax
movl n, %ebx
	// ca sa nu mi se modifice cand fac mul
movl $0, %edx

mull %ebx
addl y, %eax
movl $1, (%edi, %eax, 4)

	//a[y][x]=1, calculez pozitia liniarizata
movl y,%eax
movl n, %ebx
	// ca sa nu se modifice cand fac mul
movl $0, %edx

mull %ebx
addl x, %eax
movl $1, (%edi, %eax, 4)

addl $1, index

jmp citire_muchii	

//------------------------------------------------------------------
   subpa:
 movl $0, i

 jmp parcurge_roles

   parcurge_roles:

	// for(ecx=0, ecx<n;ecx++)
		
mov i, %ecx
cmp %ecx, n
je etexit

movl (%esi, %ecx, 4), %ebx
cmp %ebx, rolswitchmalitios
je switch_malitios
jne continua_roles2

    continua_roles:
   //afisez newline daca s-a afisat macar ceva inainte
   
  push $newLine
  call printf
  pop %ebx
  
  push $0
  call fflush
  pop %ebx
   
     
    continua_roles2:

  
addl $1, i
jmp parcurge_roles


   switch_malitios:
	//linia lui sw malitios e %ecx 
	//parcurg linia %ecx
	//initializez index coloane cu 0 (edx)
	
	//afisez ca am gasit un switch malitios si indexul lui

 
 
 pushl  i 
 push $mesaj
 call printf
 pop %ebx
 pop %ebx
  
 pushl $0
 call fflush
 pop %ebx  
  
 	 //incep sa parcurg linia 
movl $0,j

     for_coloane:
  
   	//coloana curenta e j, pusa in edx
 mov j, %edx
 cmp %edx, n
   	//am terminat coloana
 je continua_roles
   	//obtin indicele din matrice
   	
 movl  i , %eax
 movl n, %ebx
 movl $0, %edx
 mull %ebx
   
 addl j , %eax
   
 movl j, %edx
   
 movl (%edi, %eax,4),%ebx
   	// %ebx e elem curent din matrice
 cmp %ebx,ok
 je afisare1
 continua_coloana:
  
 addl $1, j
  
 jmp for_coloane
   
 afisare1:
	//aici fac afisarile pt subp A
 	//%eax e pozitia curenta
 	//%edx e coloana pe care ma aflu, j  
 
  	//trebuie sa vad ce dispozitiv e pe pozitia j
       //in roles , ca sa fac afisarile corespunzatoare
  mov j, %ebx
  mov (%esi, %ebx, 4), %eax
  
  cmp %eax, rolhost
  je mesaj_host
  cmp %eax, rolswitchmalitios
  je mesaj_switchmalitios
  cmp %eax, rolswitch
  je mesaj_switch
  cmp %eax, rolcontroller
  je mesaj_controller
  
   
 jmp continua_coloana
 
    mesaj_switchmalitios:

pushl j    
push $mesajswitchmalitios
call printf
pop %ebx
pop %ebx

push $0
call fflush
pop %ebx

jmp continua_coloana  


   mesaj_controller:

pushl j  
push $mesajcontroller
call printf
pop %ebx
pop %ebx

push $0
call fflush
pop %ebx

jmp continua_coloana
 
   mesaj_host:

pushl j  
push $mesajhost
call printf
pop %ebx
pop %ebx

push $0
call fflush
pop %ebx

jmp continua_coloana

   mesaj_switch:

pushl j 
push $mesajswitch
call printf
pop %ebx
pop %ebx

push $0
call fflush
pop %ebx

jmp continua_coloana
 
 
 
 //---------------------------------------------------------------
   subpb:
        // am in %esi roles
   	//initializez coada
   lea roles, %esi
   movl $0, ult
   movl $1, pr
   	//pentru afisare prima data sau nu
   movl $0, ok
   //if roles[0]==1:
   movl $0, %ecx
   movl $0, vf
   movl (%esi, %ecx, 4), %ebx
   cmp %ebx, rolhost
   je afisare_primadata
   
     continua_subpb:
     
   movl $1, suma
   lea viz, %esi
   	//trebuie sa marchez nodul 0 cu 1 (vizitat)
  
   movl vf, %ecx
   movl $1, (%esi, %ecx, 4)
   
   	//il adaug in coada
   addl $1, ult
   lea coada, %esi
   movl ult, %ecx
   movl $0, %eax
   movl %eax, (%esi, %ecx, 4)


   
   jmp etwhile
   
   
       continua_subpb2:
 	//daca am afisat macar ceva, afisez newline
 	//compar ok cu 0
 	
 movl ok, %ecx
 movl $0, %eax
 cmp %ecx, %eax
 jl print_newline
   
       continua_subpb3:
   
   //afisez Yes sau No
 movl suma, %ecx
 cmp %ecx, n
 je print_Yes
 jne print_No
    
   
  etwhile:
  
  movl pr, %eax
  movl ult, %ebx
  cmp %ebx, %eax
 	 //se termina while-ul
  jg continua_subpb2
  
  
  
  movl pr, %ecx
  
  lea coada, %esi
  	
  movl (%esi, %ecx, 4), %edx
  movl %edx, vf
  
  addl $1, pr
 
  movl $0, index2

  
  
  		//for (index2=0; index2<n, index2++), index2 in ecx
     etfor:
     
     movl index2, %ecx
     
     cmp %ecx, n
     je etwhile
     
     lea viz, %esi
     
     //in ebx am viz[index2]
     
     movl (%esi, %ecx, 4), %ebx
     cmp $0, %ebx
     jne continuafor
     //daca sunt egale, se continua cu a doua egalitate
     
     //iau a[vf][index2] in ebx acum ca sa l compar cu 1
     
     
     movl $0, %edx
     movl vf, %eax
     mull n
     add %ecx, %eax
     lea matrix, %edi
     movl (%edi,%eax,4),%ebx
     
    
     cmp $1, %ebx
     
     jne continuafor
     //acum clar au loc cele 2 egalitati
     
     addl $1, ult
     //viz[index2]=1
     
     lea viz, %esi
     //index2 e in ecx
     
     movl $1,(%esi, %ecx,4) 
     	//coada[ult]=index2
     	
     lea coada, %esi
     movl ult, %eax
     
     movl index2, %ecx 
     movl %ecx, (%esi,%eax,4)
     addl $1, suma
     
     //if (roles[index2]==1)
     lea roles, %esi
     
     movl (%esi, %ecx,4), %ebx
     cmp %ebx, rolhost
     jne continuafor
     
     //stiu ca am intrat in if
      
     //verific daca am mai afisat
     
     movl ok, %eax
     cmp $0, %eax
     je afisare_primadata1
     jne afisare_normala
     
     
     
     afisare_primadata1:
     
 pushl index2
 push $formatPrint1
 call printf
 pop %ebx
 pop %ebx
 
 push $0
 call fflush
 pop %ebx
 
 movl $1, ok
     
 jmp continuafor
     
     afisare_normala:
     
 pushl index2
 push $formatPrint1
 call printf
 pop %ebx
 pop %ebx
 
 push $0
 call fflush
 pop %ebx
 
 movl $1, ok

 jmp continuafor
     
 
      continuafor:
 addl $1, index2
 jmp etfor
  
  

     print_Yes:
  
 push $formatPrintYes
 call printf
 pop %ebx
 
 push $0
 call fflush 
 pop %ebx
 
 jmp etexit
 
      print_No:
  
 push $formatPrintNo
 call printf
 pop %ebx
 
 push $0
 call fflush 
 pop %ebx
 jmp etexit
   
   
     print_newline:
 
  push $newLine
  call printf
  pop %ebx
  
  push $0
  call fflush
  pop %ebx
  
 jmp continua_subpb3
   
  afisare_primadata:
   
 push vf
 push $formatPrint1
 call printf
 pop %ebx
 pop %ebx
 
 push $0
 call fflush
 pop %ebx
 
 movl $1, ok
 
 jmp continua_subpb
 
   
//-----------------------------------------------------------------------
   subpc:
   
   push $start
   push $formatRead1
   call scanf
   pop %ebx
   pop %ebx
   
   push $finish
   push $formatRead1
   call scanf
   pop %ebx
   pop %ebx
   
   //citesc cuvantul sir 
   push $sir
   push $formatReadString
   call scanf
   pop %ebx
   pop %ebx
   
   //verific daca roles[start]==3
   lea roles, %esi
   movl start, %ecx
   movl (%esi,%ecx,4), %ebx
   cmp %ebx, rolswitchmalitios
   je modifica_sir
   
   
   lea viz, %edi
   movl $0, index2
   jmp modifica_roles
   
   continua_subpc:
   
   movl $0, ult
   movl $1, pr
   
   //viz[start]=2
   
   movl start, %ecx
   movl $2, %eax
   movl %eax, (%edi,%ecx,4)
   
   addl $1, ult
   	//coada[ult]=start
   lea coada, %esi	
   movl ult, %ecx
   movl start, %eax
   movl %eax, (%esi,%ecx,4)
   
     //incep while ul 
     jmp etwhile2
     
continua_subpc2:
     
     lea viz, %esi
     //if viz[finish]==2 trb sa afisez sirul nemodificat
     //else, trb sa afisez sirul modificat
     movl finish, %ecx
     movl (%esi,%ecx,4), %ebx
     movl $2, %eax
     cmp %ebx, %eax
     
     
     
     je print_subpc
     jne modifica_sir
     
   
  
 etwhile2:
 
  movl pr, %eax
  movl ult, %ebx
  cmp %ebx, %eax
 	 //se termina while-ul
  jg continua_subpc2
  
  //vf=coada[pr]
  lea coada, %esi
  movl pr, %ecx	
  movl (%esi, %ecx, 4), %edx
  movl %edx, vf
 
  
  addl $1, pr
  //incep forul
  movl $0, index2
  lea viz, %edi
  jmp etfor2
   
   
etfor2:
  movl index2, %ecx
  cmp %ecx, n
  je etwhile2
  
  //if viz[index2]==0
  lea viz, %edi 
  movl (%edi,%ecx,4),%ebx
  movl $0, %eax
  cmp %ebx, %eax
  jne continua_for2
  
  	//if matrix[vf][index2]==1
  
  lea matrix, %edi
  movl $0, %edx
  movl vf, %eax
  mull n
  add index2,%eax
  movl (%edi, %eax,4), %ebx

  cmp $1, %ebx
  jne continua_for2
  
  	//am intrat pe ambele if uri
  addl $1, ult
  lea viz, %edi
  lea coada, %esi
  	//acum am viz-edi, coada-esi
  	//viz[index2]=2
  	
  lea viz, %edi
  movl $2, %eax
  movl %eax, (%edi, %ecx, 4)
 	 //coada[ult]=index2
  movl ult, %edx
 	 //ecx e index2
  lea coada, %esi	 
  movl %ecx, (%esi, %edx, 4)
  jmp continua_for2
  
 
 continua_for2:
 
 addl $1, index2
 jmp etfor2 

modifica_roles:

  movl index2, %ecx
  cmp %ecx, n
  je continua_subpc
  	//verific daca roles[i]==3
  movl (%esi,%ecx,4), %ebx
  cmp %ebx, rolswitchmalitios
  je modifica_viz
  
continua_for_c:
  addl $1, index2
  jmp modifica_roles
  
modifica_viz:
	//viz[i]=1
	//in ecx am i
	
  movl index2, %ecx	
  lea viz, %edi	
	
  movl $1, %eax
  movl %eax, (%edi,%ecx,4) 
  jmp continua_for_c 

modifica_sir:

 
  lea sir, %edi
  movl $0, len
  jmp etloop
  
etloop:

 movl len, %ecx
 movb (%edi, %ecx,1), %al
 cmp $0, %al
 je print_subpc
 
 
 //k are 107
 cmp $107, %al
 jle complement
 
 subb $10, %al
 continuare:
 movb %al, (%edi, %ecx, 1)
 
 
 addl $1, len 
 jmp etloop


complement:

addb $16, %al
jmp continuare


print_subpc:

push $sir
call printf
pop %ebx

push $0
call fflush
pop %ebx

jmp etexit

   etexit:
 mov $1, %eax
 mov $0, %ebx
 int $0x80
