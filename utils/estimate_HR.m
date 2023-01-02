function [HR,t] = estimate_HR(ppg,window,overlap,Fs)

window = window *Fs;
overlap = overlap*Fs;
i = 1;
ind1 = (i-1)*overlap+1;
ind2 = ind1+window-1;
while(ind2<length(ppg))
    sig = ppg(ind1:ind2);
    sig = [zeros(size(sig)) sig zeros(size(sig))];
%     [f,P] = spectral_HR(sig,Fs);
    HR(i) = prpsd(sig, Fs, 0.5, 4, 0);
%     [~,ind] = max(P);
%     HR(i) = f(ind)*60;
    t(i) = (ind1+ind2-1)/2;
    i = i+1;
    ind1 = (i-1)*overlap+1;
    ind2 = ind1+window-1;
end
end