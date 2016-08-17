function structurerandom(x1,x2,y1,y2)

global S

totalarea = abs(x1-x2)*abs(y1-y2); % total area in mm^2 (testconfiguratie)
nie = length(S.IE); %number of internal elements in configuration
nse = length(S.SE); %number of source elements in configuration
counterie=1; %counter for every extra internal element made with this algorithm
a = size(S.matrix);
nx = a(2); %number of points in the x-direction
ny = a(1); %number of points in the v-direction
dx = (x2-x1)/nx;
dy = (y2-y1)/ny;
numberofpositions = ny*nx; %number of possible endpoints of terminal segments
S.density = 1/100; %density of number of terminal segments/mm^2
radius = 0.4; %radius terminale segmenten in mm
% pressure = 20; %pressure in terminal segments in mmHg

%% for source element
for i=1:nse 
    segment=[]; %delete any existing fields from previous simulation
    Aperfusion = (sum(S.matrix(:)==i)/numberofpositions)*totalarea; %area perfused by element in mm^2
    Nterm = round(Aperfusion*S.density/2); %number of terminal segments made
    Ntot = Nterm*2 - 1; %total number of extra segments made
    
    segment(1).u(1) = S.SE(i).u(1)+(S.SE(i).v(1)-S.SE(i).u(1))/3; %coordinates of proximal end of first random element
    segment(1).u(2) = S.SE(i).u(2)+(S.SE(i).v(2)-S.SE(i).u(2))/3; %coordinates of proximal end of first random element
    
    %splitting original element and adding extra element and extra node
    if S.SE(i).sourceP == 60 
        S.IE(nie+counterie).nodes = [S.nin+1 S.SE(i).node];
        S.IE(nie+counterie).u(1) = S.SE(i).u(1)+(S.SE(i).v(1)-S.SE(i).u(1))/3; %har: segment(1).u(1)
        S.IE(nie+counterie).u(2) = S.SE(i).u(2)+(S.SE(i).v(2)-S.SE(i).u(2))/3; %segment(1).u(2)
        S.IE(nie+counterie).v(1) = S.SE(i).v(1); %distal end of source element i
        S.IE(nie+counterie).v(2) = S.SE(i).v(2);
        S.IE(nie+counterie).type = S.SE(i).type;
        S.IE(nie+counterie).length = lengte(S.IE(nie+counterie).u,S.IE(nie+counterie).v);
        S.IE(nie+counterie).radius = S.SE(i).radius;
        daughter = nie+counterie; %remember this element for simulation of random structure in other perfusion area of this element
        %har: the following lines updates source element i
        S.SE(i).v(1) = S.SE(i).u(1)+(S.SE(i).v(1)-S.SE(i).u(1))/3; %new distal coordinates for source element %har: =coordinates of proximal end of first random element
        S.SE(i).v(2) = S.SE(i).u(2)+(S.SE(i).v(2)-S.SE(i).u(2))/3; %new distal coordinates for source element
        S.SE(i).node = S.nin+1;
        S.SE(i).length = lengte(S.SE(i).u,S.SE(i).v);
        
        cubed(1:Nterm) = radius^3; %determining radius extra element using murray's law: r0^3 = r1^3+r2^3
%         S.IE(nie+counterie).radius = (S.IE(nie+counterie).radius^3 - sum(cubed))^(1/3); 
        %har: I think instead of using Nterm (number of extra segments
        %generated for one perfusion area), It's better to consider
        %pre-defined radius of the next element as 1 constant in murray's
        %law
        
    elseif S.SE(i).sourceP == 40
        S.IE(nie+counterie).nodes = [S.SE(i).node S.nin+1];
        S.IE(nie+counterie).u(1) = S.SE(i).u(1);
        S.IE(nie+counterie).u(2) = S.SE(i).u(2);
        S.IE(nie+counterie).v(1) = S.SE(i).u(1)+2*(S.SE(i).v(1)-S.SE(i).u(1))/3; %har: the source element should be splitted at 2/3 element's length
        S.IE(nie+counterie).v(2) = S.SE(i).u(2)+2*(S.SE(i).v(2)-S.SE(i).u(2))/3; %leaving the final third as new source element
        S.IE(nie+counterie).type = S.SE(i).type;
        S.IE(nie+counterie).length = lengte(S.IE(nie+counterie).u,S.IE(nie+counterie).v);
        S.IE(nie+counterie).radius = S.SE(i).radius;
        parent = nie+counterie; %remember this element for simulation of random structure in other perfusion area of this element
        
        S.SE(i).u(1) = S.SE(i).u(1)+2*(S.SE(i).v(1)-S.SE(i).u(1))/3;
        S.SE(i).u(2) = S.SE(i).u(2)+2*(S.SE(i).v(2)-S.SE(i).u(2))/3;
        S.SE(i).node = S.nin+1;
        S.SE(i).length = lengte(S.SE(i).u,S.SE(i).v);
        
        %determining radius extra element using murray's law: 
        %r0^3 = r1^3+r2^3 
        cubed=0;
        cubed(1:Nterm) = radius^3;
%         S.SE(i).radius = (S.SE(i).radius^3 - sum(cubed))^(1/3);
        %har: see my note above about murray's law
        
    end
    counterie=counterie+1;
    
    %chosing distal coordinates for first new segment, at random within
    %perfusion area
    x=round(rand*nx);
    y=round(rand*ny);
    while x == 0 || y == 0 || S.matrix(y,x) ~= i
        x=round(rand*nx);
        y=round(rand*ny);
    end
    segment(1).v(1) = x1+x*dx; %distal coordinates new segment
    segment(1).v(2) = y1+y*dy; %distal coordinates new segment
    segment(1).length = lengte(segment(1).u,segment(1).v);
    segment(1).node = S.nin+1;
    node = S.nin+1; %remember this node for other side of element
    segment(1).nodes = [];
    segment(1).parent = nan;
    segment(1).ndist = 1; %number of terminal segments distal to this segment (=1 for terminal segments by definition)

    for k=2:Nterm
        n=length([segment.ndist]); %number of already existing segments

        %create supporting circle 
        Asupport = (n+1)*Aperfusion/Ntot;
        rsupport = sqrt(Asupport/pi);

        %adding terminal segment - chosing coordinates
        flag = 0;
        for mp=1:10
            dthresh = sqrt(pi*rsupport^2/(k-1))*(-0.1*mp+1.1); %threshold value which favors coordinates with less segments
            for Ntoss=1:25
                x=round(rand*nx);
                y=round(rand*ny); 
                while  x == 0 || y == 0 || S.matrix(y,x) ~= i
                    x=round(rand*nx);
                    y=round(rand*ny);
                end
                x = x1+x*dx;
                y = y1+y*dy;
                succes = projection(dthresh,x,y,segment); %determines if x,y is accepted as new coordinates 
                if succes(1) == 1
                    flag=1;
                    break
                end
            end
            if flag == 1
                break
            end
        end
        
        segment(n+1).u(1) = segment(succes(2)).u(1);
        segment(n+1).u(2) = segment(succes(2)).u(2);
        segment(n+1).v(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
        segment(n+1).v(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
        segment(n+1).length = segment(succes(2)).length/2;
        if length(segment(succes(2)).nodes) == 2
            segment(n+1).nodes(1) = segment(succes(2)).nodes(1);
        else
            segment(n+1).nodes(1) = segment(succes(2)).node;
        end
        segment(n+1).nodes(2) = S.nin + k;
        segment(n+1).ndist = segment(succes(2)).ndist+1;
        segment(n+1).parent = segment(succes(2)).parent;

        segment(n+2).u(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
        segment(n+2).u(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
        segment(n+2).v(1) = x;
        segment(n+2).v(2) = y;
        segment(n+2).length = lengte(segment(n+2).u, segment(n+2).v);
        segment(n+2).parent = (n+1);
        segment(n+2).node = S.nin+k;
        segment(n+2).ndist = 1;

        segment(succes(2)).u(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
        segment(succes(2)).u(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
        segment(succes(2)).length = segment(succes(2)).length/2;
        segment(succes(2)).parent = (n+1);
        if length(segment(succes(2)).nodes) == 2
            segment(succes(2)).nodes(1) = S.nin+k;
        else
            segment(succes(2)).node = S.nin+k;
        end

        %adjusting number of distal terminal segments up to the root
        a=segment(n+1).parent;
        while isnan(a) == 0
            segment(a).ndist = segment(a).ndist + 1;
            a = segment(a).parent;
        end
    end
    
    %adding the new segments to the configuration of the system
    n = length([segment.ndist]);
    S.nin=S.nin+Nterm;
    for k=1:n
        if segment(k).ndist == 1
            S.nin=S.nin+1;
            S.IE(counterie+nie).u = segment(k).u;
            S.IE(counterie+nie).v = segment(k).v;
            S.IE(counterie+nie).radius = radius;
            S.IE(counterie+nie).nodes = [segment(k).node S.nin];
            S.IE(counterie+nie).length = lengte(S.IE(counterie+nie).u,S.IE(counterie+nie).v);
            S.IE(counterie+nie).type = 2;
            counterie=counterie+1;
        else
            S.IE(counterie+nie).u = segment(k).u;
            S.IE(counterie+nie).v = segment(k).v;
            cubed = 0;
            cubed(1:segment(k).ndist) = radius^3;
            S.IE(counterie+nie).radius = sum(cubed)^(1/3);
            S.IE(counterie+nie).nodes = segment(k).nodes;
            S.IE(counterie+nie).length = lengte(S.IE(counterie+nie).u,S.IE(counterie+nie).v);
            S.IE(counterie+nie).type = 1;
            counterie=counterie+1;
        end
    end
    
    %% New random segments on the other side of element
    segment=[];
    Aperfusion = (sum(S.matrix(:)==i*1.01)/numberofpositions)*totalarea; %area perfused by element in mm^2
    Nterm = round(Aperfusion*S.density/2); %aantal terminale segmenten
    Ntot = Nterm*2 - 1; %totaal aantal segmenten
    
    if S.SE(i).sourceP == 60
        segment(1).u(1) = (S.IE(daughter).u(1)+S.IE(daughter).v(1))/2;
        segment(1).u(2) = (S.IE(daughter).u(2)+S.IE(daughter).v(2))/2;
        
        S.IE(nie+counterie).nodes = [S.nin+1 S.IE(daughter).nodes(2)];
        S.IE(nie+counterie).u(1) = (S.IE(daughter).u(1)+S.IE(daughter).v(1))/2;
        S.IE(nie+counterie).u(2) = (S.IE(daughter).u(2)+S.IE(daughter).v(2))/2;
        S.IE(nie+counterie).v(1) = S.IE(daughter).v(1);
        S.IE(nie+counterie).v(2) = S.IE(daughter).v(2);
        S.IE(nie+counterie).type = S.IE(daughter).type;
        S.IE(nie+counterie).length = lengte(S.IE(nie+counterie).u,S.IE(nie+counterie).v);
        S.IE(nie+counterie).radius = S.IE(daughter).radius;
        
        S.IE(daughter).nodes(2) = S.nin+1;
        S.IE(daughter).v(1) = (S.IE(daughter).u(1)+S.IE(daughter).v(1))/2;
        S.IE(daughter).v(2) = (S.IE(daughter).u(2)+S.IE(daughter).v(2))/2;
        S.IE(daughter).length = lengte(S.IE(daughter).u,S.IE(daughter).v);
        
        %bepaling nieuwe radius dochterelement
        cubed=0;
        cubed(1:Nterm) = radius^3;
%         S.IE(nie+counterie).radius = (S.IE(nie+counterie).radius^3-sum(cubed))^(1/3);
        counterie=counterie+1;
    elseif S.SE(i).sourceP == 40
        segment(1).u(1) = (S.SE(i).u(1)+S.SE(i).v(1))/2;
        segment(1).u(2) = (S.SE(i).u(2)+S.SE(i).v(2))/2;
        
        S.IE(nie+counterie).nodes = [node S.nin+1];
        S.IE(nie+counterie).u(1) = S.IE(parent).v(1);
        S.IE(nie+counterie).u(2) = S.IE(parent).v(2);
        S.IE(nie+counterie).v(1) = (S.SE(i).u(1)+S.SE(i).v(1))/2;
        S.IE(nie+counterie).v(2) = (S.SE(i).u(2)+S.SE(i).v(2))/2;
        S.IE(nie+counterie).type = S.SE(i).type;
        S.IE(nie+counterie).length = lengte(S.IE(nie+counterie).u,S.IE(nie+counterie).v);
        S.IE(nie+counterie).radius = S.SE(i).radius;
        
%         S.SE(i) = []; %delete last part of the last element 
        counterie=counterie+1;
    end

    x=round(rand*nx);
    y=round(rand*ny);
    while x == 0 || y == 0 || S.matrix(y,x) ~= i*1.01
        x=round(rand*nx);
        y=round(rand*ny);
    end
    segment(1).v(1) = x1+x*dx;
    segment(1).v(2) = y1+y*dy;
    segment(1).length = lengte(segment(1).u,segment(1).v);
    segment(1).node = S.nin+1;
    
    segment(1).nodes = [];
    segment(1).parent = nan;
    segment(1).ndist = 1; %number of terminal segments distal to this segment (=1 for terminal segments by definition)

    for k=2:Nterm
        n=length([segment.ndist]);

        %inflating the real world parameters (supporting circle)
        Asupport = (n+1)*Aperfusion/Ntot;
        rsupport = sqrt(Asupport/pi);

        %adding terminal segment - chosing coordinates
        flag = 0;
        for mp=1:10
            dthresh = sqrt(pi*rsupport^2/(k-1))*(-0.1*mp+1.1);
            for Ntoss=1:25
                x=round(rand*nx);
                y=round(rand*ny); 
                while  x == 0 || y == 0 || S.matrix(y,x) ~= i*1.01
                    x=round(rand*nx);
                    y=round(rand*ny);
                end
                x = x1+x*dx;
                y = y1+y*dy;
                succes = projection(dthresh,x,y,segment);
                if succes(1) == 1
                    flag=1;
                    break
                end
            end
            if flag == 1
                break
            end
        end

        segment(n+1).u(1) = segment(succes(2)).u(1);
        segment(n+1).u(2) = segment(succes(2)).u(2);
        segment(n+1).v(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
        segment(n+1).v(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
        segment(n+1).length = segment(succes(2)).length/2;
        if length(segment(succes(2)).nodes) == 2
            segment(n+1).nodes(1) = segment(succes(2)).nodes(1);
        else
            segment(n+1).nodes(1) = segment(succes(2)).node;
        end
        segment(n+1).nodes(2) = S.nin + k;
        segment(n+1).ndist = segment(succes(2)).ndist+1;
        segment(n+1).parent = segment(succes(2)).parent;

        segment(n+2).u(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
        segment(n+2).u(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
        segment(n+2).v(1) = x;
        segment(n+2).v(2) = y;
        segment(n+2).length = lengte(segment(n+2).u, segment(n+2).v);
        segment(n+2).parent = (n+1);
        segment(n+2).node = S.nin+k;
        segment(n+2).ndist = 1;

        segment(succes(2)).u(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
        segment(succes(2)).u(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
        segment(succes(2)).length = segment(succes(2)).length/2;
        segment(succes(2)).parent = (n+1);
        if length(segment(succes(2)).nodes) == 2
            segment(succes(2)).nodes(1) = S.nin+k;
        else
            segment(succes(2)).node = S.nin+k;
        end

        %adjusting flow in segments distal to new terminal segment
        a=segment(n+1).parent;
        while isnan(a) == 0
            segment(a).ndist = segment(a).ndist + 1;
            a = segment(a).parent;
        end
    end

    %adding the new segments to the configuration of the system
    n = length([segment.ndist]);
    S.nin=S.nin+Nterm;
    for k=1:n
        if segment(k).ndist == 1
            S.nin=S.nin+1;
            S.IE(counterie+nie).u = segment(k).u;
            S.IE(counterie+nie).v = segment(k).v;
            S.IE(counterie+nie).radius = radius;
            S.IE(counterie+nie).nodes = [segment(k).node S.nin];
            S.IE(counterie+nie).length = lengte(S.IE(counterie+nie).u,S.IE(counterie+nie).v);
            S.IE(counterie+nie).type = 2;
            counterie=counterie+1;
        else
            S.IE(counterie+nie).u = segment(k).u;
            S.IE(counterie+nie).v = segment(k).v;
            cubed = 0;
            cubed(1:segment(k).ndist) = radius^3;
            S.IE(counterie+nie).radius = sum(cubed)^(1/3);
            S.IE(counterie+nie).nodes = segment(k).nodes;
            S.IE(counterie+nie).length = lengte(S.IE(counterie+nie).u,S.IE(counterie+nie).v);
            S.IE(counterie+nie).type = 1;
            counterie=counterie+1;
        end
    end
end


%% internal elements
for i=1:nie
    if i+nse~=5
        if i+nse ~=4
            segment=[];
            Aperfusion = (sum(S.matrix(:)==i+nse)/numberofpositions)*totalarea; %area perfused by element in mm^2
            Nterm = round(Aperfusion*S.density/2); %aantal terminale segmenten
            Ntot = Nterm*2 - 1; %totaal aantal segmenten
            
            segment(1).u(1) = S.IE(i).u(1)+(S.IE(i).v(1)-S.IE(i).u(1))/3;
            segment(1).u(2) = S.IE(i).u(2)+(S.IE(i).v(2)-S.IE(i).u(2))/3;
            %splitting original element in half and adding extra node
            
            S.IE(nie+counterie).nodes = [S.nin+1 S.IE(i).nodes(2)];
            S.IE(nie+counterie).u(1) = S.IE(i).u(1)+(S.IE(i).v(1)-S.IE(i).u(1))/3;
            S.IE(nie+counterie).u(2) = S.IE(i).u(2)+(S.IE(i).v(2)-S.IE(i).u(2))/3;
            S.IE(nie+counterie).v(1) = S.IE(i).v(1);
            S.IE(nie+counterie).v(2) = S.IE(i).v(2);
            S.IE(nie+counterie).type = S.IE(i).type;
            S.IE(nie+counterie).length = lengte(S.IE(nie+counterie).u,S.IE(nie+counterie).v);
            S.IE(nie+counterie).radius = S.IE(i).radius;
            daughter = nie+counterie;
            
            S.IE(i).v(1) = S.IE(i).u(1)+(S.IE(i).v(1)-S.IE(i).u(1))/3;
            S.IE(i).v(2) = S.IE(i).u(2)+(S.IE(i).v(2)-S.IE(i).u(2))/3;
            S.IE(i).nodes = [S.IE(i).nodes(1) S.nin+1];
            S.IE(i).length = lengte(S.IE(i).u,S.IE(i).v);
            
            %bepaling nieuwe radius dochterelement
            cubed=0;
            cubed(1:Nterm) = radius^3;
            %         S.IE(nie+counterie).radius = (S.IE(nie+counterie).radius^3-sum(cubed))^(1/3);
            counterie=counterie+1;
            
            x=round(rand*nx);
            y=round(rand*ny);
            while x == 0 || y == 0 || S.matrix(y,x) ~= i+nse
                x=round(rand*nx);
                y=round(rand*ny);
            end
            segment(1).v(1) = x1+x*dx;
            segment(1).v(2) = y1+y*dy;
            segment(1).length = lengte(segment(1).u,segment(1).v);
            segment(1).node = S.nin+1;
            
            segment(1).nodes = [];
            segment(1).parent = nan;
            segment(1).ndist = 1; %number of terminal segments distal to this segment (=1 for terminal segments by definition)
            
            for k=2:Nterm
                n=length([segment.ndist]);
                
                %inflating the real world parameters (supporting circle)
                Asupport = (n+1)*Aperfusion/Ntot;
                rsupport = sqrt(Asupport/pi);
                
                %adding terminal segment - chosing coordinates
                flag = 0;
                for mp=1:10
                    dthresh = sqrt(pi*rsupport^2/(k-1))*(-0.1*mp+1.1);
                    for Ntoss=1:25
                        x=round(rand*nx);
                        y=round(rand*ny);
                        while  x == 0 || y == 0 || S.matrix(y,x) ~= i+nse
                            x=round(rand*nx);
                            y=round(rand*ny);
                        end
                        x = x1+x*dx;
                        y = y1+y*dy;
                        succes = projection(dthresh,x,y,segment);
                        if succes(1) == 1
                            flag=1;
                            break
                        end
                    end
                    if flag == 1
                        break
                    end
                end
                
                segment(n+1).u(1) = segment(succes(2)).u(1);
                segment(n+1).u(2) = segment(succes(2)).u(2);
                segment(n+1).v(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
                segment(n+1).v(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
                segment(n+1).length = segment(succes(2)).length/2;
                if length(segment(succes(2)).nodes) == 2
                    segment(n+1).nodes(1) = segment(succes(2)).nodes(1);
                else
                    segment(n+1).nodes(1) = segment(succes(2)).node;
                end
                segment(n+1).nodes(2) = S.nin + k;
                segment(n+1).ndist = segment(succes(2)).ndist+1;
                segment(n+1).parent = segment(succes(2)).parent;
                
                segment(n+2).u(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
                segment(n+2).u(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
                segment(n+2).v(1) = x;
                segment(n+2).v(2) = y;
                segment(n+2).length = lengte(segment(n+2).u, segment(n+2).v);
                segment(n+2).parent = (n+1);
                segment(n+2).node = S.nin+k;
                segment(n+2).ndist = 1;
                
                segment(succes(2)).u(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
                segment(succes(2)).u(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
                segment(succes(2)).length = segment(succes(2)).length/2;
                segment(succes(2)).parent = (n+1);
                if length(segment(succes(2)).nodes) == 2
                    segment(succes(2)).nodes(1) = S.nin+k;
                else
                    segment(succes(2)).node = S.nin+k;
                end
                
                %adjusting flow in segments distal to new terminal segment
                a=segment(n+1).parent;
                while isnan(a) == 0
                    segment(a).ndist = segment(a).ndist + 1;
                    a = segment(a).parent;
                end
            end
            
            %adding the new segments to the configuration of the system
            n = length([segment.ndist]);
            S.nin=S.nin+Nterm;
            for k=1:n
                if segment(k).ndist == 1
                    S.nin=S.nin+1;
                    S.IE(counterie+nie).u = segment(k).u;
                    S.IE(counterie+nie).v = segment(k).v;
                    S.IE(counterie+nie).radius = radius;
                    S.IE(counterie+nie).nodes = [segment(k).node S.nin];
                    S.IE(counterie+nie).length = lengte(S.IE(counterie+nie).u,S.IE(counterie+nie).v);
                    S.IE(counterie+nie).type = 2;
                    counterie=counterie+1;
                else
                    S.IE(counterie+nie).u = segment(k).u;
                    S.IE(counterie+nie).v = segment(k).v;
                    cubed = 0;
                    cubed(1:segment(k).ndist) = radius^3;
                    S.IE(counterie+nie).radius = sum(cubed)^(1/3);
                    S.IE(counterie+nie).nodes = segment(k).nodes;
                    S.IE(counterie+nie).length = lengte(S.IE(counterie+nie).u,S.IE(counterie+nie).v);
                    S.IE(counterie+nie).type = 1;
                    counterie=counterie+1;
                end
            end
        end
    end
    
    %% New random segments on the other side of element
    segment=[];
    Aperfusion = (sum(S.matrix(:)==(i+nse)*1.01)/numberofpositions)*totalarea; %area perfused by element in mm^2
    Nterm = round(Aperfusion*S.density/2); %aantal terminale segmenten
    Ntot = Nterm*2 - 1; %totaal aantal segmenten
    
    segment(1).u(1) = (S.IE(daughter).u(1)+S.IE(daughter).v(1))/2;
    segment(1).u(2) = (S.IE(daughter).u(2)+S.IE(daughter).v(2))/2;

    S.IE(nie+counterie).nodes = [S.nin+1 S.IE(daughter).nodes(2)];
    S.IE(nie+counterie).u(1) = (S.IE(daughter).u(1)+S.IE(daughter).v(1))/2;
    S.IE(nie+counterie).u(2) = (S.IE(daughter).u(2)+S.IE(daughter).v(2))/2;
    S.IE(nie+counterie).v(1) = S.IE(daughter).v(1);
    S.IE(nie+counterie).v(2) = S.IE(daughter).v(2);
    S.IE(nie+counterie).type = S.IE(daughter).type;
    S.IE(nie+counterie).length = lengte(S.IE(nie+counterie).u,S.IE(nie+counterie).v);
    S.IE(nie+counterie).radius = S.IE(daughter).radius;

    S.IE(daughter).nodes(2) = S.nin+1;
    S.IE(daughter).v(1) = (S.IE(daughter).u(1)+S.IE(daughter).v(1))/2;
    S.IE(daughter).v(2) = (S.IE(daughter).u(2)+S.IE(daughter).v(2))/2;
    S.IE(daughter).length = lengte(S.IE(daughter).u,S.IE(daughter).v);
 
    cubed=0;
    cubed(1:Nterm) = radius^3;
%     S.IE(counterie+nie).radius = (S.IE(nie+counterie).radius^3-sum(cubed))^(1/3);
    counterie=counterie+1;

    x=round(rand*nx);
    y=round(rand*ny);
    while x == 0 || y == 0 || S.matrix(y,x) ~= (i+nse)*1.01
        x=round(rand*nx);
        y=round(rand*ny);
    end
    segment(1).v(1) = x1+x*dx;
    segment(1).v(2) = y1+y*dy;
    segment(1).length = lengte(segment(1).u,segment(1).v);
    segment(1).node = S.nin+1;
    segment(1).nodes = [];
    segment(1).parent = nan;
    segment(1).ndist = 1; %number of terminal segments distal to this segment (=1 for terminal segments by definition)

    for k=2:Nterm
        n=length([segment.ndist]);

        %inflating the real world parameters (supporting circle)
        Asupport = (n+1)*Aperfusion/Ntot;
        rsupport = sqrt(Asupport/pi);

        %adding terminal segment - chosing coordinates
        flag = 0;
        for mp=1:10
            dthresh = sqrt(pi*rsupport^2/(k-1))*(-0.1*mp+1.1);
            for Ntoss=1:25
                x=round(rand*nx);
                y=round(rand*ny); 
                while  x == 0 || y == 0 || S.matrix(y,x) ~= (i+nse)*1.01
                    x=round(rand*nx);
                    y=round(rand*ny);
                end
                x = x1+x*dx;
                y = y1+y*dy;
                succes = projection(dthresh,x,y,segment);
                if succes(1) == 1
                    flag=1;
                    break
                end
            end
            if flag == 1
                break
            end
        end

        segment(n+1).u(1) = segment(succes(2)).u(1);
        segment(n+1).u(2) = segment(succes(2)).u(2);
        segment(n+1).v(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
        segment(n+1).v(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
        segment(n+1).length = segment(succes(2)).length/2;
        if length(segment(succes(2)).nodes) == 2
            segment(n+1).nodes(1) = segment(succes(2)).nodes(1);
        else
            segment(n+1).nodes(1) = segment(succes(2)).node;
        end
        segment(n+1).nodes(2) = S.nin + k;
        segment(n+1).ndist = segment(succes(2)).ndist+1;
        segment(n+1).parent = segment(succes(2)).parent;

        segment(n+2).u(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
        segment(n+2).u(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
        segment(n+2).v(1) = x;
        segment(n+2).v(2) = y;
        segment(n+2).length = lengte(segment(n+2).u, segment(n+2).v);
        segment(n+2).parent = (n+1);
        segment(n+2).node = S.nin+k;
        segment(n+2).ndist = 1;

        segment(succes(2)).u(1) = (segment(succes(2)).u(1)+segment(succes(2)).v(1))/2;
        segment(succes(2)).u(2) = (segment(succes(2)).u(2)+segment(succes(2)).v(2))/2;
        segment(succes(2)).length = segment(succes(2)).length/2;
        segment(succes(2)).parent = (n+1);
        if length(segment(succes(2)).nodes) == 2
            segment(succes(2)).nodes(1) = S.nin+k;
        else
            segment(succes(2)).node = S.nin+k;
        end

        %adjusting flow in segments distal to new terminal segment
        a=segment(n+1).parent;
        while isnan(a) == 0
            segment(a).ndist = segment(a).ndist + 1;
            a = segment(a).parent;
        end
    end

    %adding the new segments to the configuration of the system
    n = length([segment.ndist]);
    S.nin=S.nin+Nterm;
    for k=1:n
        if segment(k).ndist == 1
            S.nin=S.nin+1;
            S.IE(counterie+nie).u = segment(k).u;
            S.IE(counterie+nie).v = segment(k).v;
            S.IE(counterie+nie).radius = radius;
            S.IE(counterie+nie).nodes = [segment(k).node S.nin];
            S.IE(counterie+nie).length = lengte(S.IE(counterie+nie).u,S.IE(counterie+nie).v);
            S.IE(counterie+nie).type = 2;
            counterie=counterie+1;
        else
            S.IE(counterie+nie).u = segment(k).u;
            S.IE(counterie+nie).v = segment(k).v;
            cubed = 0;
            cubed(1:segment(k).ndist) = radius^3;
            S.IE(counterie+nie).radius = sum(cubed)^(1/3);
            S.IE(counterie+nie).nodes = segment(k).nodes;
            S.IE(counterie+nie).length = lengte(S.IE(counterie+nie).u,S.IE(counterie+nie).v);
            S.IE(counterie+nie).type = 1;
            counterie=counterie+1;
        end
    end
end


end
            
