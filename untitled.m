





close all
clear all



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Importation des données pour le TRAITEMENT CINEMATIQUE
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % On selectionne le repertoire
disp('Selectionnez le fichier ');
[Dossier] = uigetdir ('Selectionnez le Dossier où exécuter le Script');
Extension = '*.mat'; %Traite tous les .mat
Chemin = fullfile(Dossier, Extension); % On construit le chemin
ListeFichier = dir(Chemin); % On construit la liste des fichiers

clear Y1
clear Y2
clear Y3
for i =1:length(ListeFichier)
i

    Fichier_traite = [Dossier '\' ListeFichier(i).name];
    load (Fichier_traite);

    Y1 = Data.Kinematics(1).data.MD2( Data.Kinematics(1).data.MD2>=100 & Data.Kinematics(1).data.MD2<=300 );
    duree(i,1) = mean(Y1);

    Y2 = Data.Kinematics(2).data.MD2( Data.Kinematics(2).data.MD2>=100 & Data.Kinematics(2).data.MD2<=300 );
    duree(i,2) = mean(Y2);

    Y3 = Data.Kinematics(3).data.MD2( Data.Kinematics(3).data.MD2>=100 & Data.Kinematics(3).data.MD2<=300 );
    duree(i,3) = mean(Y3);



end





























