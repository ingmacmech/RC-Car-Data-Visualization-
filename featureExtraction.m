function [ feautures,out ] = featureExtraction( input, output, window, plotFlag )
%featureExtraction extract feautueres from input data and align output
%   

n = size(input,1);
m = size(input,2);
nFeatu = 4;

feautures = zeros(n-window-1,m*nFeatu);
labelString = {'mu ','sigma ','min ','max '};


for i = 1 : n - (window-1)
    mu = mean(input(i:(i+window)-1,:),1);
    sigma = std(input(i:(i+window)-1,:),1);
    maxValue = max(input(i:(i+window)-1,:),[],1);
    minValue = min(input(i:(i+window)-1,:),[],1);
    feautures(i,:) = [mu,sigma,maxValue,minValue];
end

out = output(window:end,:);

if plotFlag == true
    figure()
    [~,ax] = plotmatrix(feautures);
    
    for i = 0 : m - 1
        for k = 0:nFeatu-1
            ax(i*nFeatu+1+k,1).YLabel.String = strcat(labelString{k+1},...
                                                      num2str(i+1));
            ax(nFeatu*m,i*nFeatu+1+k).XLabel.String = ...
                 strcat(labelString{k+1},num2str(i+1));
        end
    end
end