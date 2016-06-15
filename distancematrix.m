function A = distancematrix(x1,x2,y1,y2)
%function makes an u*v matrix to determine which element is closest by
% in an area with x-coordinates from x1 to x2
% and y-coordinates from y1 to y2
% har: I agreed that this code is suboptimal and can further improved, but
% I can see it'll take a lot of time to adjust the changes throughout the
% rest of the codes accordingly (esp Marika is still starting to get
% familiar with debugging process).

equation; %adds directioncoefficient and starting point of each element

global S
nie = length(S.IE);
nse = length(S.SE);
n=nie+nse; %total number of elements
%ed: have these numbers below predefined
nu = 100; %number of points in the u-direction %ed: horizontal; this is number of pixels, point is ill-defined
nv = 100; %number of points in the v-direction
du = (x2-x1)/nu;
dv = (y2-y1)/nv;
A = ones(nv,nu); %ed: A is the distance matrix, each element indicates which of the main vessels is closest by 
%ed: index in A is (vertical, horizontal) = (nrow ncolumn)
% vessel number in A is defined as 1..nse, nse+1..nse+nie, with 3 sources,
% 4 means first internal element

for i=0:nu-1 %ed: have i and j from 1 to nu, modify i in the calculation of b, dcrit etc
    for j=0:nv-1
        dcrit(1:n)=0; 
        %ed: distance to each of the segments for the current pixel. but there is not point in keeping the whole list
        % just remmber the index and distance of the closest by. 
        for k=1:nse
            %ed: some unreadable geometry to figure out which segment is
            %closest by. it works apparantly
            a = [(S.SE(k).u(1)-S.SE(k).v(1));(S.SE(k).u(2)-S.SE(k).v(2))];
            b = [((x1+i*du)-S.SE(k).v(1));((y1+j*dv)-S.SE(k).v(2))];
            dproj = dot(a,b)*S.SE(k).length^(-2);
            if dproj >= 0 && dproj <= 1
                a = [(-S.SE(k).u(2)+S.SE(k).v(2));(S.SE(k).u(1)-S.SE(k).v(1))];
                b = [((x1+i*du)-S.SE(k).v(1));((y1+j*dv)-S.SE(k).v(2))];
                dcrit(k) = abs(dot(a,b))/S.SE(k).length;
            else
                dcrit(k) = min((((x1+du*i)-S.SE(k).v(1))^2+((y1+dv*j)-S.SE(k).v(2))^2)^(1/2),(((x1+du*i)-S.SE(k).u(1))^2+((y1+dv*j)-S.SE(k).u(2))^2)^(1/2));
            end
            if k > 1 %ed: so we calculated the distance to a segment and now update A if this distance was less than found before
                if dcrit(k) < min(dcrit(1:(k-1))) %ed: see above, needs optimization
                    A(j+1,i+1) = k;
                end
            end
        end
        for k=1:nie
            a = [(S.IE(k).u(1)-S.IE(k).v(1));(S.IE(k).u(2)-S.IE(k).v(2))];
            b = [((x1+i*du)-S.IE(k).v(1));((y1+j*dv)-S.IE(k).v(2))];
            dproj = dot(a,b)*S.IE(k).length^(-2);
            if dproj >= 0 && dproj <= 1
                a = [(-S.IE(k).u(2)+S.IE(k).v(2));(S.IE(k).u(1)-S.IE(k).v(1))];
                b = [((x1+i*du)-S.IE(k).v(1));((y1+j*dv)-S.IE(k).v(2))];
                dcrit(k+nse) = abs(dot(a,b))/S.IE(k).length;
            else
                dcrit(k+nse) = min((((x1+du*i)-S.IE(k).v(1))^2+((y1+dv*j)-S.IE(k).v(2))^2)^(1/2),(((x1+du*i)-S.IE(k).u(1))^2+((y1+dv*j)-S.IE(k).u(2))^2)^(1/2));
            end
            if dcrit(k+nse) < min(dcrit(1:(k+nse-1)))
                A(j+1,i+1) = k+nse; %ed: with 3 sources, 4 means first internal element 
            end
        end
        %ed: what is happening here? dealing with vertical vessels, rc is
        %tan(slope), 'richtingscoefficient. apparantly defined earlier
        %har: this is to indicate the area in the opposite side that still
        %belongs to the same vessel
        %i.e: left side (1) |vert.vessel| right side (1.01)
        if A(j+1,i+1) > nse %if we are dealing with an internal element
            if abs(S.IE(A(j+1,i+1)-nse).rc) == Inf %ed vertical vessel
                if x1+i*du < S.IE(A(j+1,i+1)-nse).u(1)
                    A(j+1,i+1) = A(j+1,i+1);%ed:????? %har: Unnecessary condition
                else
                    A(j+1,i+1) = A(j+1,i+1)*1.01; %ed: ???? this is an element number, why have the 1.01? looks like a classification trick that is used later
                end
            else
                if (y1+j*dv)-S.IE(A(j+1,i+1)-nse).rc*(x1+i*du) < S.IE(A(j+1,i+1)-nse).b
                    A(j+1,i+1) = A(j+1,i+1);
                else
                    A(j+1,i+1) = A(j+1,i+1)*1.01;
                end
            end
        else %ed: same trick for source elemtns
            if abs(S.SE(A(j+1,i+1)).rc) == Inf
                if x1+i*du < S.SE(A(j+1,i+1)).u(1)
                    A(j+1,i+1) = A(j+1,i+1);
                else
                    A(j+1,i+1) = A(j+1,i+1)*1.01;
                end
            else
                if (y1+j*dv)-S.SE(A(j+1,i+1)).rc*(x1+i*du) < S.SE(A(j+1,i+1)).b
                    A(j+1,i+1) = A(j+1,i+1);
                else
                    A(j+1,i+1) = A(j+1,i+1)*1.01;
                end
            end
        end
    end    
end

end
