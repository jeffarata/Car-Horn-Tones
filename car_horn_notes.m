% Jeff Arata
% 10/8/17

% This project and the associated files were provided by Joe Hoffbeck and
% are found in his paper "Enhance Your DSP Course With These Interesting
% Projects.pdf"

function [ output ] = car_horn_notes( x, fs )
% This function takes in the sound of a car horn, x, with sampling rate fs
% and tells which of the closest notes are being played. In partcular, it
% tells whether or not an F note is being played.

notes = {'A', 'Bb', 'B', 'C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab'};

X = abs(fft(x));

[PSD, F] = pwelch(x, [], [], [], fs);
logPSD = 10*log10(PSD);                     % log scale of PSD

N = length(PSD);

figure(1)
plot(F, logPSD)

tol_db = -45;

filt_freq = F(logPSD(F < 4000) > tol_db)';  % Filter to frequencies greater than -45 db

piano_freq = 440 * 2 .^ (([1:88] - 49)/12); % Piano frequencies for comparison

% Half the frequency distance between notes for more accurate tolerances.
adap_freq_tol = 400 * (2.^(([2:89] - 49)/12) - 2.^(([1:88] - 49)/12)) / 2;

% This loop sets any octaves of the lower frequencies to zero. Once it
% reaches a zero value, it assumes the rest of the entries are harmonics
% and so cuts them out. 

for ii = 1:length(filt_freq)
    [val, key] = min(abs(filt_freq(ii) - piano_freq));
    
    filt_freq( abs(filt_freq(ii)*2*ones(1,length(filt_freq)) - filt_freq) < adap_freq_tol(key) ) = 0;
       
    if filt_freq(ii) == 0
       filt_freq = filt_freq(1:ii-1);
       break
    end    
end

% PSD values to compare at the interested frequencies.
for kk = 1:length(filt_freq)
   PSDvals(kk) = logPSD(F == filt_freq(kk)); 
end
%idx_filt_freq = round(N*filt_freq/(fs/2)+1);    % Indices of our filtered frequencies
ii=1;   % initialization

while ii < length(filt_freq)    % This block boils it down to the frequencies 
                                % where the highest PSD values are
    [tmp, key] = min(abs(filt_freq(ii) - piano_freq));
    
    % if the difference in freq between two consecutive entries is close
    % enough, the one with the smaller PSD db value is removed.
    
    if abs(filt_freq(ii+1)-filt_freq(ii)) < adap_freq_tol(key)
        [val, idx] = min(PSDvals(ii:ii+1));
        idx = idx + ii - 1;
        filt_freq(idx) = 0;
        filt_freq = filt_freq( filt_freq ~= 0);
        PSDvals(idx) = -120;
        PSDvals = PSDvals( PSDvals ~= -120 );
    else
        ii=ii+1;    % Increment
    end
end

for jj = 1:length(filt_freq)   % Loop checks if any of the frequencies are F notes
    
    [val, key] = min(abs(filt_freq(jj) - piano_freq));
    note_key = mod(key, 12) + 1; % Plus 1 as notes start at A, and 0 is not
    output{jj} = notes{note_key};      % an index in matlab. 
    
end
end

