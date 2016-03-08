function noneUnityDiag = extractNoneUnityDiagonal(S)
%extractNoneUnityDiagonal: Extracts and returns diagonal elements of 
%                     matrix S which are different from 1

% Extract all diagonal elements
allDiag = diag(S);
noneUnityDiag = allDiag(~((allDiag > 1-10^-8) & (allDiag < 1+10^-8)));

noneUnityDiag = [noneUnityDiag',ones(1,length(allDiag)-length(noneUnityDiag)-1)];
end

