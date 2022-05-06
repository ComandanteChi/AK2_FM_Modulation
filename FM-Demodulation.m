clearvars
close all
clc

M = 199;
% Liest die Daten aus dem File und gibt die abgetastete Daten zurück
[v_in, fs] = audioread('/home/chi/Desktop/Programs/Matlab/Juri/AK2_FM_Modulation/mozart_fm.wav');

Ts = 1/fs;  % Abtastperiode
% Berechnet das Differenz zwischen anliegenden Elementen von Inputsignal
% * Vektor
v_diff = diff(v_in);
% Die Länge des Array ausrechnen
N = length(v_diff);
% Erstelt das Array gefüllt mit Nullen (macht das Berechnen einfacher für
% * Matlab)
hilb_filter_coeff = zeros(M+1,1);

for i=1:1:M+1
    hilb_filter_coeff(i) = 1/(pi*(i-M/2-1));
end

hilb_imag = filter(hilb_filter_coeff,1,v_diff);

v_diff = cat(1,zeros((M+1)/2,1),v_diff);
hilb_imag = cat(1,hilb_imag,zeros((M+1)/2,1));

v_hilb = v_diff + 1i*hilb_imag;

%v_hilb = hilbert(v_diff);

v_out = abs(v_hilb); % calculate the absolute value 

%% Filter

apass = 1.;    % max. Dämpfung im Durchlassbereich
astop = 50;     % min. Dämpfung im Sperrbereich
fpass = 6e3;    % Durchlassgrenze
fstop = 8e3;    % Sperrgrenze

%% Filter entwerfen
% genau wie bei analogen Filtern mit folgenden Unterschieden:
%  * Durchlass- und Sperrgrenzen werden auf die halbe Abtastrate bezogen
%  * kein 's' als letzten Parameter; 's' kennzeichnet analogen Filterentwurf
[N,Wn] = buttord(2*fpass/fs, 2*fstop/fs,apass,astop);

[B,A] = butter(N,Wn);

v_out = filter(B,A,v_out);  % filter out 2 x 8 kHz.


% 5000 samples at the begining and 5000 in the end
% because it has some noise on the edges
v_out = v_out(5000:length(v_out)-5000);
% cut the ofset off
v_out = v_out - mean(v_out);
% calculate the maximum absolute value
v_out_max = max(abs(v_out));
% normalise it!
v_out = v_out./v_out_max;

audiowrite('mozart_orig.wav',v_out,fs);

%% Spektrum berechnen
uspec = fft(v_out);         % berechne Fast Fourier Transform (= digitale Form der Fourier-Transformation) von Signal u
N = length(uspec);      % bestimme Anzahl von Elementen in Spektrumvektor = Anzahl von Samples in u

umagspec = abs(uspec);              % bestimme Betragsspektrum
umagspec = 2/N*umagspec(1:N/2);     % bestimme einseitiges (d.h., nur positive Frequenzen) Betragsspektrum
                                    %  und skaliere (Faktor 2/N) auf physikalische Amplitudenwerte
umagspec(1) = umagspec(1)/2;        % korrigiere Gleichanteil

Df = fs/N;          % Frequenzauflösung

f = 0:Df:(N-1)*Df;  % Beschriftung der Frequenzachse
f = f(1:N/2);       % entferne negativen Frequenzanteil

figure(2)
stem(f,umagspec)
grid on