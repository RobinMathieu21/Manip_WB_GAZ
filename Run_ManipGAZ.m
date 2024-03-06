    %% Script principal pour manip GAZ
        % A executer pour post-traiter les données obtenues lors des manips whole
        % body. Ce script est à utiliser pour les données STS/BTS et WB reaching.

close all
clear all

    %% Informations sur le traitement des données

        % Données pour le traitement GAZ
C1=16.38; %Deux coeff pour le calcul du net metabolic power
C2=4.64;
nb_m_mobile = 30; % Le nombre de valeurs prises pour faire une moyenne glissante


    %% Importation des données
        %On selectionne le repertoire
disp('Selectionnez le fichier ');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
Extension = '*.xlsx'; %Traite tous les .mat
Chemin = fullfile(Dossier, Extension); % On construit le chemin
ListeFichier = dir(Chemin); % On construit la liste des fichiers

Data.Noms = ListeFichier;

    %% On procède au balayage fichier par fichier
    %On charge les fichiers
disp('POST TRAITEMENT ')

for SUJET =1:length(ListeFichier)

    SUJET
    Fichier_traite = [Dossier '\' ListeFichier(SUJET).name]; %On charge le fichier .xlsx

    T = readtable(Fichier_traite);
    Poids_sujet = str2double(table2array(T(6,2))); %On récupère le poids du sujet pour le NM
    %Data.Gaz.Poids_sujet = T(7,2); %On récupère le poids du sujet pour le NMP
    l=length(table2array(T(3:end,15)));Data.Gaz(SUJET).VO2(:,1) = str2double(table2array(T(3:end,15))); %On récupère la VO2
    l2=length(table2array(T(3:end,16)));Data.Gaz(SUJET).VCO2(:,1) = str2double(table2array(T(3:end,16))); %On récupère la VCO2
    Data.Gaz(SUJET).time(:,1) = round(86400.*str2double(table2array(T(3:end,10))));  %On récupère et convertit le temps
    Data.Gaz(SUJET).NMP2(:,1) = 1000.*(C1.*Data.Gaz(SUJET).VO2(:,1)./(60*1000)+C2.*Data.Gaz(SUJET).VCO2(:,1)./(60*1000))./str2double(table2array(T(6,2))); %On calcule le NMP OLD
    PremierBloc = table2array(T(9:17,9)); %On récupère la l'ordre   %% YO %%
    %%%%%%%%%%%%%%%%
%     Data.Gaz(1).PremierBloc(SUJET,1) = PremierBloc;
    Data.Gaz(SUJET).FC(:,1) = str2double(table2array(T(3:end,24)));
    Data.Gaz(SUJET).coeff(:,1) = str2double(table2array(T(3:end,17)));


%     if SUJET == 14
%         Data.Gaz(SUJET).time(:,1) = Data.Gaz(SUJET).time(:,1)++14;     %% POUR OLD SUELEMENT
%     end   
        %% sample a linear time vector having the same length as the trial
    lgth = Data.Gaz(SUJET).time(size(Data.Gaz(SUJET).time,1),1);
    timelin = 1:1:100*lgth;
    
    clear t_data
    clear t_data2
    clear t_dataFC
    clear x_data
    clear x_data2
    clear x_data3
    
    %reorganize data
    t_data = Data.Gaz(SUJET).time;
    x_data = Data.Gaz(SUJET).NMP2(:,1);
    x_data2 = Data.Gaz(SUJET).VO2(:,1)./Poids_sujet;
    t_data2 = linspace(t_data(2),t_data(end),100*lgth);
    

    %create a function perfectly fitting the position signal over time
    %for x data
    pp_posx=interp1(t_data,x_data,t_data2,'pchip').';
    pp_posx2=interp1(t_data,x_data2,t_data2,'pchip').';

    Data.Gaz(SUJET).NMP(1:100*lgth,2) = pp_posx; % Sampled version
    Data.Gaz(SUJET).NMP(1:100*lgth,3) = smoothdata(Data.Gaz(SUJET).NMP(1:100*lgth,2),'movmean',[1000 1000]);


    a=0;
    for i=[7.5, 15, 22.5, 36, 43.5, 51, 64.5, 72, 79.5]
        a=a+1;
        time1 = (i*60-60)*100;
        time2 = (i*60)*100;   % Entre T1 et T2 on prend une moyenne du bloc
        time3 = (i*60-240)*100;
        time4 = (i*60-210)*100;   % Enttre T3 et T4 on prend une moyenne de la baseline


        Quantifs(a,1) = mean(Data.Gaz(SUJET).NMP(time1:time2,2))-mean(Data.Gaz(SUJET).NMP(time3:time4,2)); %AireNotLiss

    end
        
    
    Quantifs(PremierBloc,2) = Quantifs(1:9,1); %% YO %%
    Data.GazEXPORT.BlocsMean(SUJET,1:9) = Quantifs(1:9,2).';  %% YO %%

    color_BL = [0.8500 0.3250 0.0980];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Plot pour vérifier
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     answer = input('saisir le numéro du sujet : ','s');
    name = append('GAZ_Sujet_n_',string(SUJET));


    Titre = append('Net Metabolic Power');
    f = figure('units','normalized','outerposition',[0 0 1 1]);

    L(1) = plot(Data.Gaz(SUJET).NMP(:,3),'LineWidth',2);hold on; 
    
    y = [0 fix(max(Data.Gaz(SUJET).NMP([1:138000 175000:end],3))+1)]; % current y-axis limits
    ylim(y)
    x = xlim; % current y-axis limits

    B(1,:)=[174/255 214/255 241/255];
    B(2,:)=[52/255 152/255 219/255];
    B(3,:)=[27/255 79/255 114/255];
    B(4,:)=[237/255 187/255 153/255];
    B(5,:)=[211/255 84/255 0/255];
    B(6,:)=[110/255 44/255 0/255];
    B(7,:)=[237/255 187/255 153/255];  %% YO %%
    B(8,:)=[211/255 84/255 0/255];   %% YO %%
    B(9,:)=[110/255 44/255 0/255];   %% YO %%
    [PremierBloc2,index] = sort(PremierBloc);
    B = B(PremierBloc,:);
    
    
    
    % Pour les BASELINES
  
    for i=[4.5, 12, 19.5, 33, 40.5, 48, 61.5, 69, 76.5]  %% YO %% 
        L(6) = plot([(i*60-60)*100 (i*60-60)*100],[y(1) y(2)],'color',color_BL); hold on;
        plot([(i*60-30)*100 (i*60-30)*100],[y(1) y(2)],'color',color_BL); hold on;

    end

    % Pour les pauses
    x2 = [(22.5*60)*100 (28.5*60)*100 (28.5*60)*100 (22.5*60)*100];
    y2 = [y(1) y(1) y(2) y(2)];
    L(2) = patch(x2,y2,'black','FaceAlpha',0.1); hold on;
    x2 = [(51*60)*100 (57*60)*100 (57*60)*100 (51*60)*100];    %% YO %%
    y2 = [y(1) y(1) y(2) y(2)];
    L(2) = patch(x2,y2,'black','FaceAlpha',0.1); hold on;

    
    % Pour les BLOCS
    j=0;
    for i=[7.5, 15, 22.5, 36, 43.5, 51, 64.5, 72, 79.5]   %% YO %%  
        j=j+1
        x2 = [(i*60-180)*100 (i*60)*100 (i*60)*100 (i*60-180)*100];
        y2 = [y(1) y(1) y(2) y(2)];
        L(2) = patch(x2,y2,B(j,:),'FaceAlpha',0.5); hold on;

    end
    
    
    xlabel('time (s)')
    ylabel('FCnorm (kJ/S/kg)')
    path = 'C:\Users\robin\Downloads\graphs';
    path = append(path,'Gaz_',name);
    saveas(gcf,path,'png');
end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Export des données
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% disp('Selectionnez le Dossier où enregistre les données.');
[Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
% Dossier = 'C:\Users\robin\Desktop\Drive google\6A - THESE\MANIP 2\MATLAB\DATA_POST_TREATED2';
save([Dossier '/' 'Data' ], 'Data');
disp('Données enregistrées avec succès !');



