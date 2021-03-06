clc;
clear;
tic;

%%inisialisasi parameter
%load dataset
data = xlsread('Swarm202.xlsx');
[banyakKota Param] = size(data);

%inisialisasi jumlah partikel
%mainkan parameter disini
jmlPart = 1000; 
maxEpoch = 100;
%maxEpoch = floor(100000/jmlPart);

%temporary variable
X = zeros(jmlPart,banyakKota+1); %vektor posisi partikel
V = []; %posisi terbaik masing2 partikel
P = []; %gradien arah
Xs = {}; %swap temporary

%%inisialisasi partikel
for i = 1:jmlPart
    %generate random uniform
    x = randperm(banyakKota);
    
    %masukan ke vektor X
    X(i,1:banyakKota) = x;
    X(i,banyakKota+1) = eucDist(X(i,1:banyakKota),data); % hitung distance
    Xs{i} = randSwap(banyakKota); %generate random swap
end

V = X;
bibit_awal = X;

%%PSO Section
for i = 1:maxEpoch
    %ambil partikel terbaik
    tmp = sortrows(X,banyakKota+1);
    pgd = tmp(1,1:banyakKota);
    p_fitness = tmp(1,banyakKota+1);
    
    for j = 1:jmlPart
        %%hitung velocity
        cx = swapConstruct(V(j,1:banyakKota),X(j,1:banyakKota));
        sx = swapConstruct(pgd,X(j,1:banyakKota));
        
        %mulai operasi dari kiri
        vid = Xs{j};
        alpha_prob = rand(1);
        
        tmpb = symetricDiff(vid,cx,alpha_prob);
        
        beta_prob = rand(1);
        
        vidt = symetricDiff(tmpb,sx,beta_prob);
        
        vi = swapArray(vidt,X(j,1:banyakKota));
        
        %hitung total jarak
        vix = eucDist(vi,data);
        
        %cek terbaik per partikel
        if(vix<X(j,banyakKota+1))
            V(j,1:banyakKota) = vi;
            V(j,banyakKota+1) = vix;
        end
        
        %masukkan ke array X
        X(j,1:banyakKota) = vi;
        X(j,banyakKota+1) = vix;
    end
    
    clc;
    percentage = (i/maxEpoch)*100;
    disp(['Progress ' num2str(percentage) '%']);
end
clc;
disp('Total jarak :');
fprintf('%.3f ', p_fitness);
disp(' ');
disp('Rute :');
disp(pgd);

toc;