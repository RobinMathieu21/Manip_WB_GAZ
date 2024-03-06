function CdM = F_mat_compute_CoM(p,masse)

m_pied = 0.0145*2;
m_mollet = 0.0465*2;
m_cuisse = 0.1*2;
m_tronc = 0.578;
m_bras = 0.028*2;
m_avtbras = 0.016*2;
m_main = 0.006*2;

% Je calcule le CdM a partir des marqueurs avec donnees de Winter
% Segment main : 
G_doigtpoignet = p.Poignet.*0.506 + p.Doigt.*0.494;
% Segment poignet-coude : 
G_poignetcoude = p.Coude.*0.43 + p.Poignet.*0.57;
% Segment coude-epaule : 
G_coudeepaule = p.Epaule.*0.436 + p.Coude.*0.564;
% Segment tronc : 
G_tronc = p.Epaule.*0.5 + p.Hanche.*0.5;
% Segment hanche-genou :
G_hanchegenou = p.Hanche.*0.433 + p.Genou.*0.567;
% Segment genou-cheville :
G_genoucheville = p.Genou.*0.433 + p.Cheville.*0.567;
% Segment pied :
G_chevillepied = p.Cheville.*0.5 + p.Pied.*0.5;

Masse_CoM = [m_main, m_avtbras, m_bras, m_tronc, m_cuisse,...
    m_mollet, m_pied].*(p.masse);
    
for CoM_j = 1:length(p.Poignet)
    
    Matrice_CoM = [G_doigtpoignet(CoM_j,:);G_poignetcoude(CoM_j,:);G_coudeepaule(CoM_j,:) ...
        ;G_tronc(CoM_j,:);G_hanchegenou(CoM_j,:);G_genoucheville(CoM_j,:) ...
        ;G_chevillepied(CoM_j,:)];
    CoM(CoM_j,:) = F_barycenter(Matrice_CoM,Masse_CoM);
    
end

CdM = CoM;
