function CoM = F_barycenter(matrice,masse)

% fonction calculant l'isobarycentre 3D de plusieurs points 
%
% matrice contient les coordonnees des points
% CoM renvoit les coordonnees de l'isobarycentre

[n,m]=size(matrice);

if m == 3 
   bary_x=0;bary_y=0;bary_z=0;
    for i = 1:n        
   bary_x=bary_x+matrice(i,1)*masse(i);
   bary_y=bary_y+matrice(i,2)*masse(i);
   bary_z=bary_z+matrice(i,3)*masse(i);   
    end
    
    CoM = [bary_x/sum(masse) , bary_y/sum(masse) , bary_z/sum(masse)];
    
else
    disp('ne fonctionne que pour des points 3D')
    stop
end

