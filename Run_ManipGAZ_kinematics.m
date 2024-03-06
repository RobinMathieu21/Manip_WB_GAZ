    %% Script principal pour manip GAZ
        % A executer pour post-traiter les données obtenues lors des manips whole
        % body. Ce script est à utiliser pour les données marche et WB
        % reaching de la manip gaz full body


close all
clear all

    %% Informations sur le traitement des données
        % Données pour le traitement cinématique
Frequence_acquisition = 200 ;  % Fréquence d'acquisition du signal cinématique
Low_pass_Freq = 5; % Fréquence passe-bas la position
Cut_off = 0.1; %pourcentage du pic de vitesse pour déterminer début et fin du mouvement
Ech_norm_kin = 1000; %Fréquence d'échantillonage du profil de vitesse normalisé en durée 
Seuil = 0.1;
Data.Gaz.sequence = ['1','1','1','2','2','2'];
Data.Gaz.sequence = ['1','1','1','2','2','2','2','2','2'];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Importation des données pour le TRAITEMENT CINEMATIQUE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % On selectionne le repertoire
disp('Selectionnez le fichier ');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
Extension = '*.mat'; %Traite tous les .mat
Chemin = fullfile(Dossier, Extension); % On construit le chemin
ListeFichier = dir(Chemin); % On construit la liste des fichiers

for i =1:length(ListeFichier)


    Fichier_traite = [Dossier '\' ListeFichier(i).name];
    load (Fichier_traite);

    pos_pied_G   = C3D.Cinematique.Donnees(:, 45:47); 
    pos_pied_D   = C3D.Cinematique.Donnees(:, 33:35);   
    pos_sacrum   = C3D.Cinematique.Donnees(:, 25:27);   
    pos_genou    = C3D.Cinematique.Donnees(:, 29:31);   
    pos_malleole = C3D.Cinematique.Donnees(:, 41:43);   
    pos_epaule   = C3D.Cinematique.Donnees(:, 1:3); 
    pos_doigt   = C3D.Cinematique.Donnees(:, 17:19); 
    pos_poignet   = C3D.Cinematique.Donnees(:, 13:15); 
    pos_coude   = C3D.Cinematique.Donnees(:, 5:7); 

    
    %On filtre le signal de position
    posfiltre_pied_G   = butter_emgs(pos_pied_G, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
    posfiltre_pied_D   = butter_emgs(pos_pied_D, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
    posfiltre_sacrum   = butter_emgs(pos_sacrum, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
    posfiltre_genou    = butter_emgs(pos_genou, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
    posfiltre_malleole = butter_emgs(pos_malleole, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
    posfiltre_epaule   = butter_emgs(pos_epaule, Frequence_acquisition, 5, Low_pass_Freq, 'low-pass', 'false', 'centered');
    posfiltre_doigt    = butter_emgs(pos_doigt, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
    posfiltre_poignet = butter_emgs(pos_poignet, Frequence_acquisition, 3, Low_pass_Freq, 'low-pass', 'false', 'centered');
    posfiltre_coude   = butter_emgs(pos_coude, Frequence_acquisition, 5, Low_pass_Freq, 'low-pass', 'false', 'centered');
   

    titre = append('Acquisition numéro ', string(i));
    if strcmp(Data.Gaz.sequence(i), '1')
        type_mvt=1;           %% REACHING
        figure('NumberTitle', 'off', 'Name', titre);
        nexttile
        plot(posfiltre_pied_D(:, 3))
        title('pied_D')
        nexttile
        plot(posfiltre_sacrum(:, 3))
        title('sacrum')
        nexttile
        plot(posfiltre_genou(:, 3))
        title('genou')
        nexttile
        plot(posfiltre_malleole(:, 3))
        title('malleole')
        nexttile
        plot(posfiltre_epaule(:, 3))
        title('epaule')
        nexttile
        plot(posfiltre_doigt(:, 3))
        title('doigt')
        nexttile
        plot(posfiltre_poignet(:, 3))
        title('poignet')
        nexttile
        plot(posfiltre_coude(:, 3))
        title('coude')
    else
        type_mvt=2;           %% Marche
        figure('NumberTitle', 'off', 'Name', titre);
        plot(posfiltre_pied_G(:, 1));hold on;plot(posfiltre_pied_D(:, 1));hold on;plot(posfiltre_sacrum(:, 3));
    end

    enableDefaultInteractivity(gca);
    [Cut] = ginput(2);

    Plage_mvmt_1_start = round(Cut(1,1));
    Plage_mvmt_1_end = round(Cut(2,1));

    Data.Clics(1,i) =  Plage_mvmt_1_start;
    Data.Clics(2,i) =  Plage_mvmt_1_end;

    [posfiltre_pied_G_cut]   = posfiltre_pied_G(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
    [posfiltre_pied_D_cut]   = posfiltre_pied_D(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
    [posfiltre_sacrum_cut]   = posfiltre_sacrum(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
    [posfiltre_genou_cut]    = posfiltre_genou(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
    [posfiltre_malleole_cut] = posfiltre_malleole(Plage_mvmt_1_start:Plage_mvmt_1_end, :);
    [posfiltre_epaule_cut]   = posfiltre_epaule(Plage_mvmt_1_start:Plage_mvmt_1_end, :);

% 
    [kine] = compute_kinematics_GazManip3(posfiltre_pied_G_cut, posfiltre_pied_D_cut, posfiltre_sacrum_cut, posfiltre_genou_cut, posfiltre_malleole_cut, posfiltre_epaule_cut, Frequence_acquisition, type_mvt, Cut_off, Ech_norm_kin, Seuil);
% 
%     
% 
    Data.Kinematics(i).data = kine;
    Data.Kinematics(i).C3D  = C3D; % 
% 
    if type_mvt==1
%         Data.Kinematics(1).MEAN(1,i) = mean(kine.amplitude2);
        Data.Kinematics(1).MEAN(1,i+3) = mean(kine.MD2)/Frequence_acquisition;
% 
    else
%         Data.Kinematics(1).MEAN(1,i+3) = kine.Moy_X_pied_G-kine.Moy_X_pied_D;
    end

end

prompt = "On enregistre ? '1' pour oui et '2' pour non    ";
x = input(prompt);

    
if x == 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Export des données
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    name = append(Data.Kinematics(i).C3D.NomSujet(1,:),'_KINE');
    disp('Enregistrement........');
%     [Dossier] = uigetdir ('Selectionnez le Dossier où enregistre les données.');
    Dossier2 =  'G:\Autres ordinateurs\Mon ordinateur portable\Drive google\6A - THESE\MANIP 3\MATLAB\Acq kine post-treated';
    disp('.....');
    save([Dossier2 '/' name ], 'Data');
    disp('Données enregistrées avec succès !');
    
end




