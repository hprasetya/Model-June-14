function c = projection(d,x,y,seg)

%function calculates the distance form point(x,y) to every already existing
%segment and determines if a point(x,y) is accepted as the distal end of a
%new terminal segment. Function returns an anrray c(A,B) with A=1 if new
%point(x,y) is accepted and with B the nearest existing segment (=1 as a starting value).

counter=0;
n=length([seg.ndist]);
c(1)=0;
dproj(1:n)=0;
dcrit(1:n)=0;
c(2)=1;

for i=1:n
    a = [(seg(i).u(1) - seg(i).v(1));(seg(i).u(2) - seg(i).v(2))];
    b = [(x - seg(i).v(1));(y - seg(i).v(2))];
    dproj(i) = dot(a,b)*seg(i).length^(-2);
    if dproj(i) >= 0 && dproj(i) <= 1
        a = [(-seg(i).u(2)+seg(i).v(2));(seg(i).u(1)-seg(i).v(1))];
        b = [(x-seg(i).v(1));(y-seg(i).v(2))];
        dcrit(i) = abs(dot(a,b))/seg(i).length;
    else
        dcrit(i) = min(((x-seg(i).v(1))^2+(y-seg(i).v(2))^2)^(1/2),((x-seg(i).u(1))^2+(y-seg(i).u(2))^2)^(1/2));
    end
    if dcrit(i) > d
        counter = counter+1;
    end
    if i > 1
        if dcrit(i) < min(dcrit(1:(i-1)))
            c(2) = i;
        end
    end
end

if counter == n
    c(1) = 1;
end