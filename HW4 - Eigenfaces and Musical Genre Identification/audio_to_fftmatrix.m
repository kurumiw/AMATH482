
function [player, X] = audio_to_fftmatrix(filename, samplenum) % audio chopper (500 samples of 5s audio clips from the input file)
% return audioplayer for checking purposes
    [y,Fs] = audioread(filename);
    y = mean(y,2); % average the left and right channels
    player = audioplayer(y,Fs);
    X = [];
    for j = 1:samplenum
        randstart = round((length(y)-(5*Fs))*rand(1),0);
        choppedsignal = y(randstart:randstart+5*Fs);
        S = fft(choppedsignal);
        X = [X S];
    end

end
