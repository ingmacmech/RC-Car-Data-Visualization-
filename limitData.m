function [ in, out, newLength ] = limitData( input, output, lim )
%UNTITLED gives back only the data in a certain rainge set by lim
%   Detailed explanation goes here

nIn = size(input,1);
mIn = size(input,2);
mOut = size(output,2);
i = 1;

axTemp = abs(input(:,2)-mean(input(:,2)));
azTemp = abs(input(:,3)-mean(input(:,3)));
for n = 1 : nIn
    if(axTemp(n) < lim && azTemp(n) < lim )
        in(i,:) = input(n,:);
        out(i,:) = output(n,:);
        i = i + 1;
    end
end

newLength = size(in,1);
