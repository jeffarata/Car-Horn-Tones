% Jeff Arata
% 10/8/17

% This project and the associated files were provided by Joe Hoffbeck and
% are found in his paper "Enhance Your DSP Course With These Interesting
% Projects.pdf"

% Car Horn Tones
% This script looks at car horn honks to see if they produce the note F as
% is claimed by some websites. There are two files tested here, one of a
% 1995 Ford Explorer and the other a 2010 Toyota Prius.

% Notes coded by numbers
%
%   Note    Number
%    A        1
%    Bb       2
%    B        3
%    C        4
%    C#       5
%    D        6
%    Eb       7
%    E        8
%    F        9
%    F#       10
%    G        11
%    Ab       12
%

clear;
clc;

for jj = 1:2
    [x, fs] = audioread(['car_horn_', int2str(jj), '.wav']);

    notes = car_horn_notes(x, fs);

    F_check = false;

    for ii = 1:length(notes)

        fprintf('The car horn plays an %s note.\n', notes{ii})
        if notes{ii} == 'F'
            F_check = true;
        else
        end     
    end

    % print out if there is an F note or note
    if F_check
        fprintf('The car horn does indeed play an F!\n\n')
    else
        fprintf('The car horn does not play an F note.\n\n')
    end

end