function [IN,nin]=MakeNodeTable(IE,SE)

%% DEFINITION OF THE CONNECTIVITY OF THE MODEL: the node table
% now generate a table of internal nodes from the info you have above
% this works for nodes with as many connections as you want, but typically
% 3

nie=length(IE);
nse=length(SE);

% total number of internal nodes
nin=max([IE.nodes]);  



%no connections at start
for i=1:nin, 
    IN(i).nconnect=0;
    IN(i).nsources=0;
end;




% fill the internal connections based on the definition of IE,  
for ie=1:nie
    node(1)=IE(ie).nodes(1); 
    node(2)=IE(ie).nodes(2);

    for j=1:2
        k=node(j);
        IN(k).nconnect=IN(k).nconnect+1;
        nc=IN(k).nconnect;
        IN(k).cn(nc)=node(3-j); % 3-j means 1=>2 and 2=>1
        IN(k).ie(nc)=ie; % points back to element table
    end;
end;

% fill the connections to sources
for se=1:nse,
    k=SE(se).node;
    IN(k).nsources=IN(k).nsources+1;
    IN(k).se(IN(k).nsources)=se;
end;

