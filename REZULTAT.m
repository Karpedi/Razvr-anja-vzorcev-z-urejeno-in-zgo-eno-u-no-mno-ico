

%  All rights reserved. Licensed under the Academic Free License version R2020b.
% 
%  
% 
%  Poročilo predstavi bistvo razvrščanja s prileganjem ...

%dodamo vsakemu vzorcu še kateremu razredu pripada
U1 = [1,7,1; 1.5,8,1; 2,5.5,1; 2,9,1; 2.5,6.5,1; 2.5,8,1; 2.5,10,1; 3,4.5,1;3,9,1;
    3.5,5.5,1; 3.5,8,1; 4,7.5,1; 4.5,3.5,1; 4.5,4.5,1; 4.5,6,1; 5,5,1; 5,7,1; 7,6.5,1];

U2 = [3.5,9.5,2; 3.5,10.5,2; 4.5,8,2; 4.5,10.5,2; 5,9,2; 5.5,5.5,2; 5.5,7.5,2; 5.5,11,2; 
    6,9.5,2; 6.5,8,2; 6.5,10,2; 7,5.5,2; 7.5,7.5,2; 7.5,9,2; 8,6,2; 8.5,7,2; 8.5,8.5,2];

U12 = [U1; U2];

figure %2D prostor vsi vzorci
for i = 1:1:18
    hold on
    Prva = plot(U1(i,1),U1(i,2),'bx');
    
end

for i = 1:1:17
    hold on
    Druga = plot(U2(i,1),U2(i,2),'ks');
end
title('2D prostor značilk')
legend ([Prva,Druga],'U1', 'U2','Location', 'SouthEast')

%1-NN prvi preizkus razpoznavanja

Evklid = zeros(35,35);
rezultat = zeros(35, 1);%uspešnost

%računamo evklidsko razdaljo do vseh vzorcev
for i = 1:1:35     
    for j = 1:1:35      
          Evklid(i, j) = sqrt((U12(j,1) - U12(i,1))^2 + (U12(j,2) - U12(i,2))^2);  
          if i == j
              Evklid(i, j) = inf;
          end
    end
end

%iskanje najmanjše razdalje
minEvklid = Evklid;
[Mnoz1,I1] = min(minEvklid,[],2);
for i = 1:1:35
    minEvklid(i, I1(i)) = inf;
end
[Mnoz2,I2] = min(minEvklid, [],2); 

%določanje pravilnosti razvrščanja
for i = 1:1:35 
    if i<=18
        if I1(i)<= 18
            if (Mnoz1(i)==Mnoz2(i)) && I1(i)> 18
                rezultat(i) = inf;
            else
                rezultat(i) = 1;
            end
        else
            if Mnoz1(i)==Mnoz2(i)
                rezultat(i) = inf;
            else
                rezultat(i) = 0;
            end
        end
    end

    if i>18
        if I1(i)> 18
            if (Mnoz1(i)==Mnoz2(i)) && I1(i)<= 18
                rezultat(i) = inf;
            else
                rezultat(i) = 1;
            end
        else
            if Mnoz1(i)==Mnoz2(i)
                rezultat(i) = inf;
            else
                rezultat(i) = 0;
            end
        end
    end
end

%odstotek pravilno razvrščenih
prav = 0;
for i = 1:1:35
    if rezultat(i) <=1
        prav = prav + rezultat(i);
    end
end
Rpr = (prav*100)/35;
JA=['Povprečna pravilnost razpoznavanja : ',num2str(Rpr)];
disp(JA)

%urejanje & zgoščanje%

% izločimo napačno razvrščene 
U1_2 = zeros (25, 3); 
j = 1;
for i = 1:1:35
    if rezultat(i) == 1
        U1_2(j,:) = U12(i,:);
        j = j+1;
    end
end
    
figure 
title('Urejena množica')
for i = 1:1:15
    hold on
    Prva = plot(U1_2(i,1),U1_2(i,2),'bx');
end
for i = 16:1:25
    hold on
    Druga = plot(U1_2(i,1),U1_2(i,2),'ks');
end
legend ([Prva,Druga],'U1', 'U2','Location', 'SouthEast')
%zgoščevanje--->
%1preverajanje 1elemnt v store ostale v grabbag
 STORE = U1_2(1,:);
 GRABBAG = U1_2(2:25,:);
 
Evklid_urejena = zeros (1,length(GRABBAG) );
rezultat_urejena = zeros (length(GRABBAG) , 1);%uspešnost 

for i = 1:1:1  
    for j = 1:1:length(GRABBAG)     
          Evklid_urejena(i, j) = sqrt((GRABBAG(j,1) - STORE(i,1))^2 + (GRABBAG(j,2) - STORE(i,2))^2);  
          
    end
end
%najmanjša razdalja
[M_urejena,I_urejena] = min(Evklid_urejena,[],1);
%določanje pravilnosti razvrščanja
for i = 1:1:length(GRABBAG) 
    if GRABBAG(i,3) == STORE (I_urejena(i),3)
        rezultat_urejena(i) = 1;
    else
        rezultat_urejena(i) = 0;
    end
end

%Napačno razvrščen
[M_napaka,I_napaka] = min(rezultat_urejena);

%2 preverjanje[ponavljamo toliko iteracij dokler ne pride najboljše
%razpoznavanje
 STORE = [STORE; GRABBAG(I_napaka,:)];
 GRABBAGdva = [GRABBAG(1:(I_napaka-1),:); GRABBAG((I_napaka+1):length(GRABBAG),:)];
  
Evklid_urejena = zeros (2,length(GRABBAGdva) );
rezultat_urejena = zeros (length(GRABBAGdva) , 1);          
for i = 1:1:2      
    for j = 1:1:length(GRABBAGdva)      
          Evklid_urejena(i, j) = sqrt((GRABBAGdva(j,1) - STORE(i,1))^2 + (GRABBAGdva(j,2) - STORE(i,2))^2);  
          
    end
end
[M_urejena,I_urejena] = min(Evklid_urejena,[],1); 

for i = 1:1:length(GRABBAGdva)
    if GRABBAGdva(i,3) == STORE (I_urejena(i),3)
        rezultat_urejena(i) = 1;
    else
        rezultat_urejena(i) = 0;
    end
end

[M_napaka,I_napaka] = min(rezultat_urejena);


%3preverjanje
 STORE = [STORE; GRABBAGdva(I_napaka,:)];
 GRABBAGtri = [GRABBAGdva(1:(I_napaka-1),:); GRABBAGdva((I_napaka+1):length(GRABBAGdva),:)];
 
Evklid_urejena = zeros (3,length(GRABBAGtri) );
rezultat_urejena = zeros (length(GRABBAGtri) , 1);  

for i = 1:1:3      
    for j = 1:1:length(GRABBAGtri)      
          Evklid_urejena(i, j) = sqrt((GRABBAGtri(j,1) - STORE(i,1))^2 + (GRABBAGtri(j,2) - STORE(i,2))^2);
    end
end


[M_urejena,I_urejena] = min(Evklid_urejena,[],1);

for i = 1:1:length(GRABBAGtri) 
    if GRABBAGtri(i,3) == STORE (I_urejena(i),3)
        rezultat_urejena(i) = 1;
    else
        rezultat_urejena(i) = 0;
    end
end

[M_napaka,I_napaka] = min(rezultat_urejena);


%4preverjanje
 STORE = [STORE; GRABBAGtri(I_napaka,:)];
 GRABBAGstiri = [GRABBAGtri(1:(I_napaka-1),:); GRABBAGtri((I_napaka+1):length(GRABBAGtri),:)];
 
Evklid_urejena = zeros (4,length(GRABBAGstiri) );
rezultat_urejena = zeros (length(GRABBAGstiri) , 1);   

for i = 1:1:4      
    for j = 1:1:length(GRABBAGstiri)     
          Evklid_urejena(i, j) = sqrt((GRABBAGstiri(j,1) - STORE(i,1))^2 + (GRABBAGstiri(j,2) - STORE(i,2))^2);  
    end
end

[M_urejena,I_urejena] = min(Evklid_urejena,[],1); 

for i = 1:1:length(GRABBAGstiri) 
    if GRABBAGstiri(i,3) == STORE (I_urejena(i),3)
        rezultat_urejena(i) = 1;
    else
        rezultat_urejena(i) = 0;
    end
end

[M_napaka,I_napaka] = min(rezultat_urejena);
 

%5preverjanje
 STORE = [STORE; GRABBAGstiri(I_napaka,:)];
 GRABBAGpet = [GRABBAGstiri(1:(I_napaka-1),:); GRABBAGstiri((I_napaka+1):length(GRABBAGstiri),:)];
 
Evklid_urejena = zeros (5,length(GRABBAGpet) );
rezultat_urejena = zeros (length(GRABBAGpet) , 1);      

for i = 1:1:5      
    for j = 1:1:length(GRABBAGpet)     
          Evklid_urejena(i, j) = sqrt((GRABBAGpet(j,1) - STORE(i,1))^2 + (GRABBAGpet(j,2) - STORE(i,2))^2);  
    end
end
[M_urejena,I_urejena] = min(Evklid_urejena,[],1);

for i = 1:1:length(GRABBAGpet) 
    if GRABBAGpet(i,3) == STORE (I_urejena(i),3)
        rezultat_urejena(i) = 1;
    else
        rezultat_urejena(i) = 0;
    end
end

[M_napaka,I_napaka] = min(rezultat_urejena);
%prikaz grafa zgoščene množice
figure 
title('Zgoščena množica')
for i = 1:1:length(STORE)
    hold on
    if STORE(i,3)==1
        Prva = plot(STORE(i,1),STORE(i,2),'bx');
    else
        Druga = plot(STORE(i,1),STORE(i,2),'ks');
    end
end
legend ([Prva,Druga],'U1', 'U2','Location', 'SouthEast')

%uspešnost zgoščene množice%
Evklid_zgoscena = zeros (length(STORE),length(U12));
rezultat_zgoscena = zeros (35, 1); %uspešnost         
%izračunamo evklidsko do vseh vzorcev
for i = 1:1:length(STORE)      
    for j = 1:1:length(U12) 
          Evklid_zgoscena(i, j) = sqrt((U12(j,1) - STORE(i,1))^2 + (U12(j,2) - STORE(i,2))^2);  
    end
end

%iskanje najmanjše razdalje
[M_zgoscena,I_zgoscena] = min(Evklid_zgoscena,[],1);

%pravilno razvrščeni
for i = 1:1:35 
    if U12(i,3) == STORE (I_zgoscena(i),3)
        rezultat_zgoscena(i) = 1;
    else
        rezultat_zgoscena(i) = 0;
    end
end

%Pravilno razvrščeni v odstotkih
rezzgo = 0;
for i = 1:1:35 
    rezzgo = rezzgo + rezultat_zgoscena(i);
end

Rzg = (rezzgo*100)/35;
Zgoscenourejeno=['Pravilno razvrščeni [zgoščena]: ',num2str(Rzg)];
disp(Zgoscenourejeno)
